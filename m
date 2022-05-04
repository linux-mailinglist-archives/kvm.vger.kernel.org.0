Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D427451AC60
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 20:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376705AbiEDSKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 14:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376540AbiEDSJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 14:09:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4FCB5A0B0
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 10:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651685192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AxkTcPmk/s+qgBgTI+JGCtm1W6V+bkC5oNvBdsahWD8=;
        b=hOdzfnBEobLtINAt6HOS7n1+grqLd2Gg2WV5lw+8fby/jkwtMoPu/faRZdnca/kMWC3r4P
        W95LqxIBu6PYYJ/MMvq3eSVCZJkfEojX1lUkVMnH2ODd+Iq6yfO/akOhHmo/91Sn/s+GzJ
        YpMuu0FSNUCnXz6ASsvour18nChSHfc=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-k_aRyZbNNAeEeYeBS-9_YQ-1; Wed, 04 May 2022 13:26:31 -0400
X-MC-Unique: k_aRyZbNNAeEeYeBS-9_YQ-1
Received: by mail-il1-f197.google.com with SMTP id j7-20020a056e02218700b002cd9e2f0ac7so1027251ila.16
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 10:26:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AxkTcPmk/s+qgBgTI+JGCtm1W6V+bkC5oNvBdsahWD8=;
        b=0FiX0VRpOgrds7/oT6bI7avnb5/gKgOaVPEV7c/qbIILNlAlE9/b00Pkel3ERGZr9L
         OBuRBs/wEZ2dumQj2YkjMMQQq3XvXKCvkYJ3Ca0Pvtdf3+UiHBRl6kM/XpBga0uVckpL
         nz5QPX+Gmt9BR5I+jb/liOINhHQsjAd02Pd0Kt2MIX7QZCAxcHLKA9AYdBKDUM9XK/EI
         U1yrTeZCwqOhgR1ugA5/2z8A1lqjPUttm4rqN0JErqh//dr5WASG8q2RWJd8l2XGMPFh
         epRk8VOlT4DPcqPaCnhwkZoqfgA/jQASXQvBsXzHF0oYD0piP+Sc1Kt3l+7WaCQpi5oS
         IGHQ==
X-Gm-Message-State: AOAM532/HgYOhDsRF3vP/G238k6QX1kvJJtWOmGGfnyy8TS+hnJO8Fet
        Vr/4FV9jIKGqtxo2/GuUFc0KC1RzfYKBvye+GfKjrN8/tB/VM9hu0AraWtCBxcb3gqSze71GmLX
        qYgGLg4TP55jz
X-Received: by 2002:a05:6e02:194f:b0:2cd:fc1e:77ad with SMTP id x15-20020a056e02194f00b002cdfc1e77admr8449194ilu.52.1651685190815;
        Wed, 04 May 2022 10:26:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxB+UtOG8d1KoB+Mcnd4kp28/hRMISR6NMvfBSAVZCvFtcmcC69wTYmpA2312RVZetqqRrY6g==
X-Received: by 2002:a05:6e02:194f:b0:2cd:fc1e:77ad with SMTP id x15-20020a056e02194f00b002cdfc1e77admr8449181ilu.52.1651685190440;
        Wed, 04 May 2022 10:26:30 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id w63-20020a025d42000000b0032b3a781760sm4799819jaa.36.2022.05.04.10.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 10:26:30 -0700 (PDT)
Date:   Wed, 4 May 2022 13:26:28 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v3 1/3] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <YnK3RCW3RAMhDY2d@xz-m1.local>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-2-shivam.kumar1@nutanix.com>
 <YnBXuXTcX2OC6fQU@xz-m1.local>
 <8433df8b-fd88-1166-f27b-a87cfc08c50c@nutanix.com>
 <YnExg/3McGZK3YdR@xz-m1.local>
 <25888a8f-ef44-ec69-071c-609ddd7661dc@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <25888a8f-ef44-ec69-071c-609ddd7661dc@nutanix.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 04, 2022 at 12:03:57PM +0530, Shivam Kumar wrote:
> 
> On 03/05/22 7:13 pm, Peter Xu wrote:
> > On Tue, May 03, 2022 at 12:52:26PM +0530, Shivam Kumar wrote:
> > > On 03/05/22 3:44 am, Peter Xu wrote:
> > > > Hi, Shivam,
> > > > 
> > > > On Sun, Mar 06, 2022 at 10:08:48PM +0000, Shivam Kumar wrote:
> > > > > +static inline int kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
> > > > > +	u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;
> > > > > +	struct kvm_run *run = vcpu->run;
> > > > > +
> > > > > +	if (!dirty_quota || (pages_dirtied < dirty_quota))
> > > > > +		return 1;
> > > > > +
> > > > > +	run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
> > > > > +	run->dirty_quota_exit.count = pages_dirtied;
> > > > > +	run->dirty_quota_exit.quota = dirty_quota;
> > > > Pure question: why this needs to be returned to userspace?  Is this value
> > > > set from userspace?
> > > > 
> > > 1) The quota needs to be replenished once exhasuted.
> > > 2) The vcpu should be made to sleep if it has consumed its quota pretty
> > > quick.
> > > 
> > > Both these actions are performed on the userspace side, where we expect a
> > > thread calculating the quota at very small regular intervals based on
> > > network bandwith information. This can enable us to micro-stun the vcpus
> > > (steal their runtime just the moment they were dirtying heavily).
> > > 
> > > We have implemented a "common quota" approach, i.e. transfering any unused
> > > quota to a common pool so that it can be consumed by any vcpu in the next
> > > interval on FCFS basis.
> > > 
> > > It seemed fit to implement all this logic on the userspace side and just
> > > keep the "dirty count" and the "logic to exit to userspace whenever the vcpu
> > > has consumed its quota" on the kernel side. The count is required on the
> > > userspace side because there are cases where a vcpu can actually dirty more
> > > than its quota (e.g. if PML is enabled). Hence, this information can be
> > > useful on the userspace side and can be used to re-adjust the next quotas.
> > I agree this information is useful.  Though my question was that if the
> > userspace should have a copy (per-vcpu) of that already then it's not
> > needed to pass it over to it anymore?
> This is how we started but then based on the feedback from Sean, we moved
> 'pages_dirtied' to vcpu stats as it can be a useful stat. The 'dirty_quota'
> variable is already shared with userspace as it is in the vcpu run struct
> and hence the quota can be modified by userspace on the go. So, it made
> sense to pass both the variables at the time of exit (the vcpu might be
> exiting with an old copy of dirty quota, which the userspace needs to know).

Correct.

My point was the userspace could simply cache the old quota too in the
userspace vcpu struct even if there's the real quota value in vcpu run.

No strong opinion, but normally if this info is optional to userspace I
think it's cleaner to not pass it over again to keep the kernel ABI simple.

> 
> Thanks.
> > > Thank you for the question. Please let me know if you have further concerns.
> > > 
> > > > > +	return 0;
> > > > > +}
> > > > The other high level question is whether you have considered using the ring
> > > > full event to achieve similar goal?
> > > > 
> > > > Right now KVM_EXIT_DIRTY_RING_FULL event is generated when per-vcpu ring
> > > > gets full.  I think there's a problem that the ring size can not be
> > > > randomly set but must be a power of 2.  Also, there is a maximum size of
> > > > ring allowed at least.
> > > > 
> > > > However since the ring size can be fairly small (e.g. 4096 entries) it can
> > > > still achieve some kind of accuracy.  For example, the userspace can
> > > > quickly kick the vcpu back to VM_RUN only until it sees that it reaches
> > > > some quota (and actually that's how dirty-limit is implemented on QEMU,
> > > > contributed by China Telecom):
> > > > 
> > > > https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_qemu-2Ddevel_cover.1646243252.git.huangy81-40chinatelecom.cn_&d=DwIBaQ&c=s883GpUCOChKOHiocYtGcg&r=4hVFP4-J13xyn-OcN0apTCh8iKZRosf5OJTQePXBMB8&m=y6cIruIsp50rH6ImgUi28etki9RTCTHLhRic4IzAtLa62j9PqDMsKGmePy8wGIy8&s=tAZZzTjg74UGxGVzhlREaLYpxBpsDaNV4X_DNdOcUJ8&e=
> > > > 
> > > > Is there perhaps some explicit reason that dirty ring cannot be used?
> > > > 
> > > > Thanks!
> > > When we started this series, AFAIK it was not possible to set the dirty ring
> > > size once the vcpus are created. So, we couldn't dynamically set dirty ring
> > > size.
> > Agreed.  The ring size can only be set when startup and can't be changed.
> > 
> > > Also, since we are going for micro-stunning and the allowed dirties in
> > > such small intervals can be pretty low, it can cause issues if we can
> > > only use a dirty quota which is a power of 2. For instance, if the dirty
> > > quota is to be set to 9, we can only set it to 16 (if we round up) and if
> > > dirty quota is to be set to 15 we can only set it to 8 (if we round
> > > down). I hope you'd agree that this can make a huge difference.
> > Yes. As discussed above, I didn't expect the ring size to be the quota
> > per-se, so what I'm wondering is whether we can leverage a small and
> > constant sized ring to emulate the behavior of a quota with any size, but
> > with a minimum granule of the dirty ring size.
> This would be an interesting thing to try. I've already planned efforts to
> optimise it for dirty ring interface. Thank you for this suggestion.
> 
> Side question: Is there any plan to make it possible to dynamically update
> the dirty ring size?

No plan that I'm aware of..

After I checked: kvm_dirty_ring_get_rsvd_entries() limits our current ring
size, which is hardware dependent on PML.  It seems at least 1024 will
still be a work-for-all case, but not sure how it'll work in reality since
then soft_limit of the dirty ring will be relatively small so it'll kick to
userspace more often.  Maybe that's not a huge problem for a throttle
scenario.  In that case the granule will be <=4MB if it'll work.

> > > Also, this approach works for both dirty bitmap and dirty ring interface
> > > which can help in extending this solution to other architectures.
> > Is there any specific arch that you're interested outside x86?
> x86 is the first priority but this patchset targets s390 and arm as well.

I see.

> > 
> > Logically we can also think about extending dirty ring to other archs, but
> > there were indeed challenges where some pages can be dirtied without a vcpu
> > context, and that's why it was only supported initially on x86.
> This is an interesting problem and we are aware of it. We have a couple of
> ideas but they are very raw as of now.

I think a default (no-vcpu) ring will solve most of the issues, but that
requires some thoughts, e.g. the major difference between ring and bitmap
is that ring can be full while bitmap cannot.. We need to think careful on
that when it comes.

The other thing is IIRC s390 has been using dirty bits on the pgtables
(either radix or hash based) to trap dirty, so that'll be challenging too
when connected with a ring interface because it could make the whole thing
much less helpful..

So from that pov I think your solution sounds reasonable on that it
decouples the feature with the interface, and it also looks simple.

> > 
> > I think it should not be a problem for the quota solution, because it's
> > backed up by the dirty bitmap so no dirty page will be overlooked for
> > migration purpose, which is definitely a benefit.  But I'm still curious
> > whether you looked into any specific archs already (x86 doesn't have such
> > problem) so that maybe there's some quota you still want to apply elsewhere
> > where there's no vcpu context.
> Yes, this is kind of similar to one of the ideas we have thought. Though,
> there are many things which need a lot of brainstorming, e.g. the ratio in
> which we can split the overall quota to accomodate for dirties with no vcpu
> context.

I'm slightly worried it'll make things even more complicated.

Only until we're thinking seriously on non-x86 platforms (since again x86
doesn't have this issue afaict..): I think one thing we could do is to dig
out all these cases and think about whether they do need any quota at all.

IOW, whether the no-vcpu dirty context are prone to have VM live migration
converge issue.  If the answer is no, IMHO a simpler approach is we can
ignore those dirty pages for quota purpose.

I think that's a major benefit of your approach comparing to the full dirty
ring approach, because you're always backed by the dirty bitmap so there's
no way of data loss.  Dirty ring's one major challenge is how to make sure
all dirty PFNs get recorded and meanwhile we don't interrupt kvm workflow
in general.

One thing I'd really appreciate is if this solution would be accepted from
the kernel POV and if you plan to work on a qemu version of it, please
consider reading the work from Hyman Huang from China Telecom on the dirty
limit solution (which is currently based on dirty ring):

https://lore.kernel.org/qemu-devel/cover.1648748793.git.huangy81@chinatelecom.cn/

Since they'll be very similar approaches to solving the same problem.
Hopefully we could unify the work and not have two fully separate
approaches even if they should really share something in common.

Thanks,

-- 
Peter Xu

