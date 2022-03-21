Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA814E1E88
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 01:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343948AbiCUAwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Mar 2022 20:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbiCUAwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Mar 2022 20:52:45 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007AD140F3
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 17:51:21 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id h63so15158239iof.12
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 17:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z96X8M63Et3y7PJDqcFSz7o73T5HSrhCu2qF6/QRNXg=;
        b=VJLo3j74Q654FlzIJBSn3mXOoQUKvuJQxOUXGiX0Df2q6wQz56gbM8zEMQ337ZQ9aD
         6+Q/CNsiXsMeEGF8tUGRqSsce6yXJAECXiq6AROWecOa0T0hO1eF5mm9r4JhFzI4D/ul
         aV9EGCwqXaAV8QhkJ+JIW3f2V5tSIbzPWm6a30iOmQ2EUTZ8jFdUbIiSWH7joyufjD3y
         cNfbQRrtKjQ418L6Ai6euG81jKQJ5EHLnBdnYQ8EYnsIjyq9eeXa5r5ojr7TF8XglQpD
         uFIpYH2bGax361VrCBRClwVZw0YIIfazTnJbEHnRtd3sMZzYb0/6jPRnivG8JPAtlA2T
         WxxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z96X8M63Et3y7PJDqcFSz7o73T5HSrhCu2qF6/QRNXg=;
        b=qmuOPWKdpqUJZdy+K4g3yHm63uvCVyw17pkXUlx5qZ35ZA1Jh5xV87IKD2YRLBO+vF
         RqD3KVpiRp7+LjZAplSuuKZS4VfnQVJMsSCP0WDKXHRQi939l+7mSVlpwdIlbJjRTprn
         OMPoHQk98t6odUcM/XToUwjY0JNWpzRjWvUDGIQodRWNSr798OBGUh45LeKMD2XGrqaw
         991RlkLxTIIhTM28wzVtQD/h8DDide2LKLNPyt+HTPoHcqUyPwSnxQLuMKO/mkvN5vss
         v+porJgL4k2DUl5XYw6IYI/H72pzHCbgqM2w+QWGBu47tahkjS3CtWb2zgQhHGLSwn9K
         Uo2A==
X-Gm-Message-State: AOAM531yzFtFZXq9JyCgFXbIXNeUIilWx21xAnYi9UOW0H8R5coaKRYk
        CdUt2O5ju4fHcELlIqxn9fcrwg==
X-Google-Smtp-Source: ABdhPJwXzJvtxxZiT9kHMg8huqU9BdX8iCLsGBQ3ZQELVJXQ4Kc89wEYYeuIn+HeIvLWU3RdxGZtag==
X-Received: by 2002:a6b:750c:0:b0:641:3b39:7b24 with SMTP id l12-20020a6b750c000000b006413b397b24mr9109157ioh.139.1647823881141;
        Sun, 20 Mar 2022 17:51:21 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id i5-20020a6bf405000000b00645be60c31csm7880265iog.23.2022.03.20.17.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Mar 2022 17:51:20 -0700 (PDT)
Date:   Mon, 21 Mar 2022 00:51:17 +0000
From:   Oliver Upton <oupton@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
Message-ID: <YjfMBYsse95znupa@google.com>
References: <YjTRyssYQhbxeNHA@google.com>
 <0bff64ae-0420-2f69-10ba-78b9c5ac7b81@redhat.com>
 <YjWNfQThS4URRMZC@google.com>
 <e48bc11a5c4b0864616686cb1365dfb4c11b5b61.camel@infradead.org>
 <a6011bed-79b4-72ab-843c-315bf3fcf51e@redhat.com>
 <3548e754-28ae-f6c4-5d4c-c316ae6fbbb0@redhat.com>
 <100b54469a8d59976bbd96f50dd4cd33.squirrel@twosheds.infradead.org>
 <9ca10e3a-cd99-714a-76ad-6f1b83bb0abf@redhat.com>
 <YjbrOz+yT4R7FaX1@google.com>
 <9afd33cb-4052-fe15-d3ae-69a14ca252b0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9afd33cb-4052-fe15-d3ae-69a14ca252b0@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 20, 2022 at 02:39:34PM +0100, Paolo Bonzini wrote:
> On 3/20/22 09:52, Oliver Upton wrote:
> > What do you folks think about having a new R/O vCPU attribute that
> > returns a { TOD, guest_tsc } pair? I believe that would immediately
> > satisfy the needs of upstream to implement clock-advancing live
> > migration.
> 
> I don't think this adds much.  The missing link is on the destination side,
> not the source side.

I think it'll work:

 Source:
  - Pick a vCPU and save its { TOD, guest_TSC } pair
  - Save the tsc offset of every vCPU
  - Using all of the offsets, calculate the drift of all the follower
    vCPUs from the leader vCPU (from step 1)
  - Save the TSC frequency

 Destination:
  - Restore the TSC frequency
  - Read the { TOD, guest_TSC } pair for the first vCPU
  - Compare with the source value to work out delta_guest_TSC and
    delta_TOD
  - Apply delta_guest_TSC to all vCPUs in a VM
  - If you want to account for realtime, apply guest_tsc_freq *
    delta_TOD to every vCPU in the VM
  - Account for drift between leader/follower vCPUs

Userspace has some math to do, but IMO it needs to until we have a
better mechanism for helping the guest clean up a slow migration.
It does eliminate the need for doing TSC scaling in userspace, which
I think is the trickiest piece of it all.

Alternative could be to say that the VM has a single, authoritative {
TOD, guest_TSC } clock that can be read or written. Any vCPU offsets
then account for guest-induced drift in TSCs.

> To recap, the data that needs to be migrated from source to destination is
> the hostTSC+hostTOD pairing (returned by KVM_GET_CLOCK) plus one of each of
> the following:
> 
> * either guestTSCOffset or a guestTSC synced with the hostTSC
> 
> * either guestTODOffset or a guestTOD synced with the hostTOD.
> 
> * either guestTSCScale or hostTSCFreq
> 
> Right now we have guestTSCOffset as a vCPU attribute, we have guestTOD
> returned by KVM_GET_CLOCK, and we plan to have hostTSCFreq in sysfs. It's a
> bit mix-and-match, but it's already a 5-tuple that the destination can use.
> What's missing is a ioctl on the destination side that relieves userspace
> from having to do the math.

That ioctl will work fine, but userspace needs to accept all the
nastiness that ensues. If it yanks the guest too hard into the future
it'll need to pick up the pieces when the guest kernel panics.

--
Thanks,
Oliver
