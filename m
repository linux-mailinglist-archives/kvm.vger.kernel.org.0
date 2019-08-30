Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B22CA2C58
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 03:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfH3Bc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 21:32:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50424 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727213AbfH3Bc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 21:32:56 -0400
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B0B972A09DB
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2019 01:32:55 +0000 (UTC)
Received: by mail-pf1-f198.google.com with SMTP id v134so3985878pfc.18
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 18:32:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XC2aHf7wGh4YyvbrnfKO3wOWnGfvfhL781P+M7KJBG8=;
        b=RCUgVmrPH8zUtPW1HjUdfdCQ+BQ59LkDUVBZzmfGLxUwm7+ikV276VTe4UGRH3oTD+
         bc7L2e5R5syM65yfX+rcowUmbLBJX3UNhcB3ASp/dtzjMDi8C4YhxU9x6ovaPNmNTUw5
         a5BfyZy+n9QS7yG3GU/Udw49/Ud+K3oHiu2HLXOqwlDQUSmchAZ+apcSsoSZFcnGK4ZI
         g/O0FD5Qkn+ELMUASI6iWXyDEjZdFUEdl+ZgQBaeTzoiZ7s2udIN7x5ZI4LIpB3Bb7jX
         mPPe7xvQ4TLYc0F4MmssTzjmA3lpeUWf0weOwt1HE/ELYv6tdAJZJjfrNYMMK4t5Rhri
         N+NQ==
X-Gm-Message-State: APjAAAXMclK7ueHNhSI93e/zTiqa0OoAjZFA7ei8H0AgHEY+ch5gIRCZ
        pi8NF6mNx7/8p8up+LxlTz80TZwMP+V7ErP5TjxpAb/XOPZGRfNmPkLOhv2G3QDGwDLpaDfjL1P
        TkTTx54Ye29TK
X-Received: by 2002:aa7:84d7:: with SMTP id x23mr15190682pfn.53.1567128774716;
        Thu, 29 Aug 2019 18:32:54 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz/xUTCyZ30fUpBQgbLlIUWBTsXlz+VM8DCnGq3pXutJN6a6zRJ/ukArdMjaGx5/eHR1wWLXw==
X-Received: by 2002:aa7:84d7:: with SMTP id x23mr15190673pfn.53.1567128774604;
        Thu, 29 Aug 2019 18:32:54 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 67sm5336780pjo.29.2019.08.29.18.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 18:32:53 -0700 (PDT)
Date:   Fri, 30 Aug 2019 09:32:43 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v2 0/4] KVM: selftests: Introduce VM_MODE_PXXV48_4K
Message-ID: <20190830013243.GL8729@xz-x1>
References: <20190829022117.10191-1-peterx@redhat.com>
 <20190829164638.zu3srhl6i77auyhh@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190829164638.zu3srhl6i77auyhh@kamzik.brq.redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 06:46:38PM +0200, Andrew Jones wrote:
> Tested on AArch64. Looks good.

Thanks!

-- 
Peter Xu
