Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDCF575785
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 00:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241113AbiGNWTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 18:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241079AbiGNWTT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 18:19:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27192201B1
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 15:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657837156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4G9IwM3+cIcTTAWec47K+7HkIXA9vq/H/84QHGv7+B4=;
        b=hQeQawrTSx2Q5riOIxYYy38fkRrWv/XrDpBH5FUtx/t1gswmtBUxOOt4MgZFZctH4wAUxN
        W3z6hQEYVQVUDahJC0IjbfqkNl1GmVcZUI864fpa+WWDQOlbbG1tSTLn/KkWVErN8MXbzp
        x9q3ZcYrfx/0qZgrHIDItlHs6MSBaDk=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-Wamv7TCJOx-lPZHzpSTR7w-1; Thu, 14 Jul 2022 18:19:10 -0400
X-MC-Unique: Wamv7TCJOx-lPZHzpSTR7w-1
Received: by mail-qv1-f70.google.com with SMTP id m11-20020a0cfbab000000b004738181b474so2068428qvp.6
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 15:19:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4G9IwM3+cIcTTAWec47K+7HkIXA9vq/H/84QHGv7+B4=;
        b=K2KvKCDA4JSLvk0N65d9E4C1O7dG3+++PMAFGsBQbo/wLVcnLYcvn+4jntUNMtW0L6
         +GyHrM8a6BThoX/yoZFp9t+axZ4p4boCt/3pWCE+utYNsfS3UtPqwdviAnuvho8otcWh
         KR8shwTgOQKSmK2cDVvioArqDEKtIy+UqvkmGCmKhd5XV6HugYM/wlx46gJZjyOPBizq
         vBeJPpLS9ZAcuLLNdo35r6RkYDxe8l6qKAlUjEUFwiA9h7NMXz1wEFF+EgST8miTPGb6
         jfAC0MyT1lWAgAsLSCeyGk4L4IM5CPTOU+OEpQQjXBL9hNbd3eMQffV1o5F2ToUcLw6k
         fZ5Q==
X-Gm-Message-State: AJIora+ladyybJNmtckgSSLRlLFpiEatqHzgpH+8B/uzEGIxP5iMGuxJ
        HTnMRf4KfoekA75KlavT1ZXgOHnj0yIoF3pTEB3RyKd3hGbDY7ZUQfAgXD5DRwGjqk+Sc3ZERAq
        Y7NZ07DPo0BEW
X-Received: by 2002:a05:620a:3ce:b0:6b5:b62c:c9f8 with SMTP id r14-20020a05620a03ce00b006b5b62cc9f8mr7907083qkm.620.1657837149883;
        Thu, 14 Jul 2022 15:19:09 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vwZrO0GihtDgq3EOhbb4qDRj6P5Nol5ssW4M5GH+QZGE5/1VlBVR7bhMtw32nZrPGard3qVw==
X-Received: by 2002:a05:620a:3ce:b0:6b5:b62c:c9f8 with SMTP id r14-20020a05620a03ce00b006b5b62cc9f8mr7907068qkm.620.1657837149627;
        Thu, 14 Jul 2022 15:19:09 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-37-74-12-30-48.dsl.bell.ca. [74.12.30.48])
        by smtp.gmail.com with ESMTPSA id r17-20020ac85211000000b0031bf4dd8a39sm2453456qtn.56.2022.07.14.15.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 15:19:08 -0700 (PDT)
Date:   Thu, 14 Jul 2022 18:19:07 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Shivam Kumar <shivam.kumar1@nutanix.com>,
        Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v4 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <YtCWW2OfbI4+r1L3@xz-m1.local>
References: <87h75fmmkj.wl-maz@kernel.org>
 <bf24e007-23fd-2582-ec0c-5e79ab0c7d56@nutanix.com>
 <878rqomnfr.wl-maz@kernel.org>
 <Yo+gTbo5uqqAMjjX@google.com>
 <877d68mfqv.wl-maz@kernel.org>
 <Yo+82LjHSOdyxKzT@google.com>
 <b75013cb-0d40-569a-8a31-8ebb7cf6c541@nutanix.com>
 <2e5198b3-54ea-010e-c418-f98054befe1b@nutanix.com>
 <YtBanRozLuP9qoWs@xz-m1.local>
 <YtCBBI+rU+UQNm4p@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YtCBBI+rU+UQNm4p@google.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 14, 2022 at 08:48:04PM +0000, Sean Christopherson wrote:
> On Thu, Jul 14, 2022, Peter Xu wrote:
> > Hi, Shivam,
> > 
> > On Tue, Jul 05, 2022 at 12:51:01PM +0530, Shivam Kumar wrote:
> > > Hi, here's a summary of what needs to be changed and what should be kept as
> > > it is (purely my opinion based on the discussions we have had so far):
> > > 
> > > i) Moving the dirty quota check to mark_page_dirty_in_slot. Use kvm requests
> > > in dirty quota check. I hope that the ceiling-based approach, with proper
> > > documentation and an ioctl exposed for resetting 'dirty_quota' and
> > > 'pages_dirtied', is good enough. Please post your suggestions if you think
> > > otherwise.
> > 
> > An ioctl just for this could be an overkill to me.
> >
> > Currently you exposes only "quota" to kvm_run, then when vmexit you have
> > exit fields contain both "quota" and "count".  I always think it's a bit
> > redundant.
> > 
> > What I'm thinking is:
> > 
> >   (1) Expose both "quota" and "count" in kvm_run, then:
> > 
> >       "quota" should only be written by userspace and read by kernel.
> >       "count" should only be written by kernel and read by the userspace. [*]
> > 
> >       [*] One special case is when the userspace found that there's risk of
> >       quota & count overflow, then the userspace:
> > 
> >         - Kick the vcpu out (so the kernel won't write to "count" anymore)
> >         - Update both "quota" and "count" to safe values
> >         - Resume the KVM_RUN
> > 
> >   (2) When quota reached, we don't need to copy quota/count in vmexit
> >       fields, since the userspace can read the realtime values in kvm_run.
> > 
> > Would this work?
> 
> Technically, yes, practically speaking, no.  If KVM doesn't provide the quota
> that _KVM_ saw at the time of exit, then there's no sane way to audit KVM exits
> due to KVM_EXIT_DIRTY_QUOTA_EXHAUSTED.  Providing the quota ensure userspace sees
> sane, coherent data if there's a race between KVM checking the quota and userspace
> updating the quota.  If KVM doesn't provide the quota, then userspace can see an
> exit with "count < quota".

This is rare false positive which should be acceptable in this case (the
same as vmexit with count==quota but we just planned to boost the quota),
IMHO it's better than always kicking the vcpu, since the overhead for such
false is only a vmexit but nothing else.

> 
> Even if userspace is ok with such races, it will be extremely difficult to detect
> KVM issues if we mess something up because such behavior would have to be allowed
> by KVM's ABI.

Could you elaborate?  We have quite a few places sharing these between
user/kernel on kvm_run, no?

> 
> > > ii) The change in VMX's handle_invalid_guest_state() remains as it is.
> > > iii) For now, we are lazily updating dirty quota, i.e. we are updating it
> > > only when the vcpu exits to userspace with the exit reason
> > > KVM_EXIT_DIRTY_QUOTA_EXHAUSTED.
> > 
> > At least with above design, IMHO we can update kvm_run.quota in real time
> > without kicking vcpu threads (the quota only increases except the reset
> > phase for overflow).  Or is there any other reason you need to kick vcpu
> > out when updating quota?
> 
> I'm not convinced overflow is actually possible.

Yeah from that part I second you.  I don't really think it'll even happen
in practise, but I'd still like to make sure we won't introduce an ioctl
for the overflow only.

-- 
Peter Xu

