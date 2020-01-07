Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFEBB132AB4
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 17:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgAGQEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 11:04:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23410 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728266AbgAGQEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 11:04:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578413048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6/pI4t6B9z0wRX+NvUB89xIHygZ7s0TFKH3LWLJINv4=;
        b=glV97bbJAGPgV+M2Z2fZhusGO2pk1Tpa3fpFcZweCUliJCFYkYztEkHU0u84/EuJ+6Hxhz
        kVerEg3TwknY9k4ypTB00idi937GZyxMHliG2gqdoNYKg9H3TC4LAg+WqJTh+wop/ubgPQ
        IY3I2qiC4Atp+vBWE07Y3WauqRBzpcc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-zigPcgfsN-GOQBxD2V1Hvg-1; Tue, 07 Jan 2020 11:04:07 -0500
X-MC-Unique: zigPcgfsN-GOQBxD2V1Hvg-1
Received: by mail-qk1-f199.google.com with SMTP id u10so106124qkk.1
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2020 08:04:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6/pI4t6B9z0wRX+NvUB89xIHygZ7s0TFKH3LWLJINv4=;
        b=PKFTJxvpDD/wnQP2HzywZUtPOOjUGT1pt4mdJsbufiFCUyazab8MxjhD8T6k44YhKw
         7dtOGR+mEOmUHMHnM7nBzRsOJp/01YJ294rzVTx8mwXvBVZKFEE5RZEelJZ4C2N43Fpn
         ia369dM37kreR8+eqpZJ6RuIOvHQO+JRK3Q4ywKcem6wQ2JIQ3sFxjY/uMzpF6sFXALa
         /41a1YF95prcS3wLgkAH1EfMcRRdZwbVfLe1dzX6WTUwKJqMNi/bR/zBNZsjFQA7jldo
         VddlNrTMjiM0s7a+EJqBNi54egc7uisVEKpjb3wXEGgOUGDRfmyQqyT5BHuAadQ4ydpq
         X21w==
X-Gm-Message-State: APjAAAWJWoWkfV8ScxQqOSlhggDZNp5e3a6ouJCxdDzh1lBRsqR5fmT8
        azuPef/j5Y7Re0EkQ95+Eziz8+HZOWjJBgfP5jWPsiLf8qd1zO1O9JF/FH1BiGn+QeT95o02UOR
        KqYqi7lIWTHL4
X-Received: by 2002:aed:2d67:: with SMTP id h94mr78673828qtd.74.1578413046804;
        Tue, 07 Jan 2020 08:04:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqw66uIFnVme9AqF60F5anI9TjXT0ppMeOA6QoIMEfNwjdJGOKZ3GP3xMn0fUgfQqx9ibtRZXQ==
X-Received: by 2002:aed:2d67:: with SMTP id h94mr78673801qtd.74.1578413046612;
        Tue, 07 Jan 2020 08:04:06 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id k50sm47999qtc.90.2020.01.07.08.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 08:04:05 -0800 (PST)
Date:   Tue, 7 Jan 2020 11:04:04 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cannon Matthews <cannonmatthews@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 3/8] KVM: selftests: Add configurable demand paging
 delay
Message-ID: <20200107160404.GH219677@xz-x1>
References: <20191216213901.106941-1-bgardon@google.com>
 <20191216213901.106941-4-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191216213901.106941-4-bgardon@google.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 16, 2019 at 01:38:56PM -0800, Ben Gardon wrote:
> When running the demand paging test with the -u option, the User Fault
> FD handler essentially adds an arbitrary delay to page fault resolution.
> To enable better simulation of a real demand paging scenario, add a
> configurable delay to the UFFD handler.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

