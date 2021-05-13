Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C7737F3DD
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 10:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhEMIHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 04:07:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52580 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231523AbhEMIG7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 04:06:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620893150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VDqpVG5nZvDDm4obyS6Icgk8AYhvJi0sT/Vy0U5YIZs=;
        b=f+P+KQhJR6nV1iYXPYfGXy9IBgFOYhotXf9uVkNwN8t6iSkYQOg4zLXyCckIfbwEmxu3OZ
        4vA4rJxTkQW92mzrFPdwpZ0EjPxBeK5ZNceJ5HFmgIfthI0Gq16sR3wBKOS2jiZEXPNqJ+
        9XUkrN+y9T/JAkRg2mGBFJE9bbThbzQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234--JZg0YrWMXeyRjAbWjqzZQ-1; Thu, 13 May 2021 04:05:48 -0400
X-MC-Unique: -JZg0YrWMXeyRjAbWjqzZQ-1
Received: by mail-ej1-f70.google.com with SMTP id nd10-20020a170907628ab02903a324b229bfso8121918ejc.7
        for <kvm@vger.kernel.org>; Thu, 13 May 2021 01:05:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VDqpVG5nZvDDm4obyS6Icgk8AYhvJi0sT/Vy0U5YIZs=;
        b=Cz2++LA9GUxE7KALUHqq/UNmp6jL8FbSewDmr3ybZ7Lrai20otettWTXJSkwoksS8Y
         gAaR5lt09ZZnoSB3eWCA4hLl4lnh09KtrGHLptAQgNDkWUqMFUPbH2xd4rVCKqfsZOqi
         /iVUSVPJKYAPCRN0bAe/NPWndz5shl0MeJE/NlIvCAz4G9uH/+Z5MQOJpN3OntbYs53s
         R+aPELk/A3AGrxEiRtVh7M2ZMK3vtWUH6joL2Ll1BUIn0iqEdHpGien8KgJRLjA42PGx
         zCpm1IQ+F7GFT7Og4fYr5wi+p9QMtzK7aem33jX1ZD9yKDTYEmJARKSpuRIyGs3gv3Ym
         MhhQ==
X-Gm-Message-State: AOAM531tkimHIt7rVO1qqN4JXSIq0f/ME23nWZj4B3sf/PfNh++34Zhu
        YNb4ZRH27nsaiX1AdYIom/fPJr9WZMVuFPb0hpR2pqSbhQ77o1eYJ6Dlbf7MeIMBwvPXEbPYLkg
        kYfI4eNgq6GkJ
X-Received: by 2002:a17:907:ea6:: with SMTP id ho38mr7937137ejc.357.1620893147361;
        Thu, 13 May 2021 01:05:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOCHK0tMO9+mnC0XSGsxFUlqtyPsrTEwy2/rOnVkz5KReRdAulhVI/0zOM/TLdCxoXrucHhQ==
X-Received: by 2002:a17:907:ea6:: with SMTP id ho38mr7937128ejc.357.1620893147226;
        Thu, 13 May 2021 01:05:47 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id c9sm1848819edv.24.2021.05.13.01.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 01:05:46 -0700 (PDT)
Date:   Thu, 13 May 2021 10:05:39 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com
Subject: Re: [PATCH v3 4/5] KVM: selftests: Add exception handling support
 for aarch64
Message-ID: <20210513080539.iruamqsbiykqig3w@gator>
References: <20210513002802.3671838-1-ricarkol@google.com>
 <20210513002802.3671838-5-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513002802.3671838-5-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021 at 05:28:01PM -0700, Ricardo Koller wrote:
> Add the infrastructure needed to enable exception handling in aarch64
> selftests. The exception handling defaults to an unhandled-exception
> handler which aborts the test, just like x86. These handlers can be
> overridden by calling vm_install_vector_handler(vector) or
> vm_install_exception_handler(vector, ec). The unhandled exception
> reporting from the guest is done using the ucall type introduced in a
> previous commit, UCALL_UNHANDLED.
> 
> The exception handling code is heavily inspired on kvm-unit-tests.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   2 +-
>  .../selftests/kvm/include/aarch64/processor.h |  63 +++++++++
>  .../selftests/kvm/lib/aarch64/handlers.S      | 124 +++++++++++++++++
>  .../selftests/kvm/lib/aarch64/processor.c     | 131 ++++++++++++++++++
>  4 files changed, 319 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

