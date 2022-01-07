Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645D5487025
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 03:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344618AbiAGCGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 21:06:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54124 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344420AbiAGCGQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jan 2022 21:06:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641521176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UG+D6uWjEAVn11kZk2peQMRnZXsetoAzRyhjRXwbIow=;
        b=SLfoSjboKPZmsuNytA/WEjykOe4LY6Y+TnHXVpoYDRF3VMg7AfV4YIbPLNKUyHdzAHlbIz
        NGLjIYNjmZv+1vn+whrEXSZdysTXjiChKwBJI3QYPmlfCCKG6+q+0WwjSSGl3ro3eu/2++
        ehFanuWXgh6P2HlO4VAeOspF/fbeS00=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-2-nA9bP2PH-k3vKBFkRwEQ-1; Thu, 06 Jan 2022 21:06:15 -0500
X-MC-Unique: 2-nA9bP2PH-k3vKBFkRwEQ-1
Received: by mail-pl1-f197.google.com with SMTP id q14-20020a170902dace00b00148e2c4fe06so763008plx.15
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 18:06:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UG+D6uWjEAVn11kZk2peQMRnZXsetoAzRyhjRXwbIow=;
        b=HPXTt/6YMmMVhy4NozIaXYuiSfO2IXF+SpZ/XfaOK9fh5YpcMLozr5njy7MNSnJU1B
         3kLs5s4JIl4eGOqH9nB92/Axf0IVQ2pdMw5JNQPznzA+U0hG8XtqThj2u6juON5mY8I3
         v2KY3bHjxcVSJEPWih/+wRMhPIPYnerKcfrCKuXFUF02R8NwV+YvMlFUX3JBR6bspy59
         8j2x1geg7aJioA08AdMFadOMJARvQwiu3kbZ6rMU3cgG6tM6m8+9U0flDqoXHNFWjDtf
         1iWmNVFggIqCZAC+acRxKIaQMfG5TIMeqAx3nUR7oaoYRQKRh6xB6hP1gpWT0G7AU0J5
         ivRg==
X-Gm-Message-State: AOAM530xsb4eQiQ7lyVMO8eXc19DlgcfgG8Demr1Bp8FE+0JZpmNfGbH
        g18PaJfFaCL+YUqHUZBjhfUe0rHODQXF7ZHRK3zS2livljAIjAkRbdicmgUaIJrJgueZWHytiEw
        u2tg22P/xvzt0
X-Received: by 2002:a17:90b:1c07:: with SMTP id oc7mr13148598pjb.127.1641521173914;
        Thu, 06 Jan 2022 18:06:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxLhtJYgw2ze+eHA/KXUj9kK5h8F14cR5QvKy0YCdz6PeWQNOOdpf5h5LGqrUt2qHXTEYAeTw==
X-Received: by 2002:a17:90b:1c07:: with SMTP id oc7mr13148575pjb.127.1641521173673;
        Thu, 06 Jan 2022 18:06:13 -0800 (PST)
Received: from xz-m1.local ([191.101.132.79])
        by smtp.gmail.com with ESMTPSA id b13sm3572506pfo.37.2022.01.06.18.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 18:06:13 -0800 (PST)
Date:   Fri, 7 Jan 2022 10:06:05 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 09/13] KVM: x86/mmu: Split huge pages when dirty
 logging is enabled
Message-ID: <YdegDZPkPyoSHw5A@xz-m1.local>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-10-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-10-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021 at 10:59:14PM +0000, David Matlack wrote:
> When dirty logging is enabled without initially-all-set, attempt to
> split all huge pages in the memslot down to 4KB pages so that vCPUs
> do not have to take expensive write-protection faults to split huge
> pages.
> 
> Huge page splitting is best-effort only. This commit only adds the
> support for the TDP MMU, and even there splitting may fail due to out
> of memory conditions. Failures to split a huge page is fine from a
> correctness standpoint because we still always follow it up by write-
> protecting any remaining huge pages.

One more thing: how about slightly document the tlb flush skipping behavior in
commit message, or, in the function to do the split?  I don't see any problem
with it but I'm just not sure whether it's super obvious to anyone.

-- 
Peter Xu

