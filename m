Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B742D6FA31E
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 11:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjEHJTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 05:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjEHJTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 05:19:34 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19D72137
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 02:19:32 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-94ef0a8546fso686396066b.1
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 02:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683537571; x=1686129571;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dWHWiXfsrvQvmgpyUniXuDRDiysQGzJY0miwvsWIwyI=;
        b=bggqgAozm9TJ75S4ksy2TFHCpeLoYpktCJ14208MvndYOe3cYF5Nh3sJzTq+2Oo2dj
         NwACpuLPRg2mMRIuQfac/b0/NLCmXSxSrtixJD/QSjKzm5m+ljsAxYmjk8p6A274TuvC
         fTuRYIsNy35PyIA4iDoMi9fcKoalohjZgJbOq1DN5ta4mFeyPuBgZC7KmT4YWW5NUnP6
         YTtIok+DqBgKgSCElEDbHUTkJv9uexA55fKjymv+AcOAJoz1htGCbI/IRAd4BTcZukTl
         XaTEo7AtR3MNR8w4/yJjI7aTfKdcstC6ihmkav7ib3nJMiVkhVD0DfkjOyjaObFTFi38
         vYvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683537571; x=1686129571;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dWHWiXfsrvQvmgpyUniXuDRDiysQGzJY0miwvsWIwyI=;
        b=Dyhb2yJioF92q+ua6olr8uDXT6h4W1KoaEZA3RMRqXPz6HEt+0Ah7GJpxF6wN9URh6
         noW8mu/iCHTgQdK4H9SLG2FPQPqeabs8SFXUchuAaCKBHgYtBef+vRLihFz6Mtntprzg
         tq7QmAPG6vqTIh90i+V+q/fAOG/9GQVIxrSAllcT6VZ+5YisaK+w8VUx5pW0E/OVH0vx
         k46gfj5Zk9GQ3P7dB1rtrkIHJf1eHFWVPhdmyUlK3WU2CMkdF5+OreQw6qCO5+90UQvg
         sFXc3ZM2AwCjk/ny+Lbx69GDx1e5PdRU8txX2d18nN3SM3p06PyRM+GyjoAa5R7igdC2
         1IVw==
X-Gm-Message-State: AC+VfDzERTlUOWAOvZimu869wNtk/flY6Wp2LIqnb20W5+jmASf6FgXO
        Au9CsCm6H/AJYHLXiaQy61MiibCHYEVQvir0BTU=
X-Google-Smtp-Source: ACHHUZ4Et9hTM4XTR9bYa2t4KH/x0CO0MAXv0VOBtBlK/b0xQp+WYvoJOjlKAt5a5Ubpsqx6p9dmag==
X-Received: by 2002:a17:906:7303:b0:965:6d21:48bc with SMTP id di3-20020a170906730300b009656d2148bcmr9032176ejc.75.1683537571052;
        Mon, 08 May 2023 02:19:31 -0700 (PDT)
Received: from ?IPV6:2003:f6:af27:500:653d:9c74:8bdf:2820? (p200300f6af270500653d9c748bdf2820.dip0.t-ipconnect.de. [2003:f6:af27:500:653d:9c74:8bdf:2820])
        by smtp.gmail.com with ESMTPSA id bw12-20020a170906c1cc00b00965cd15c9bbsm4746270ejb.62.2023.05.08.02.19.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 02:19:30 -0700 (PDT)
Message-ID: <773d257a-a4ca-23c6-9421-c2805423aa0e@grsecurity.net>
Date:   Mon, 8 May 2023 11:19:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 0/6] KVM: MMU: performance tweaks for heavy CR0.WP
 users
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>
Cc:     Greg KH <greg@kroah.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, stable@vger.kernel.org,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <167949641597.2215962.13042575709754610384.b4-ty@google.com>
 <190509c8-0f05-d05c-831c-596d2c9664ac@grsecurity.net>
 <ZB7oKD6CHa6f2IEO@kroah.com> <ZC4tocf+PeuUEe4+@google.com>
 <0c47acc0-1f13-ebe5-20e5-524e5b6930e3@grsecurity.net>
 <026dcbfe-a306-85c3-600e-17cae3d3b7c5@grsecurity.net>
 <ZDmEGM+CgYpvDLh6@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZDmEGM+CgYpvDLh6@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry for the late reply, I've been traveling the past three weeks.

On 14.04.23 18:49, Sean Christopherson wrote:
> +Jeremi
> 
> On Fri, Apr 14, 2023, Mathias Krause wrote:
>> On 06.04.23 15:22, Mathias Krause wrote:
>>> On 06.04.23 04:25, Sean Christopherson wrote:
>>>> These are quite risky to backport.  E.g. we botched patch 6[*], and my initial
>>>> fix also had a subtle bug.  There have also been quite a few KVM MMU changes since
>>>> 5.4, so it's possible that an edge case may exist in 5.4 that doesn't exist in
>>>> mainline.
>>>
>>> I totally agree. Getting the changes to work with older kernels needs
>>> more work. The MMU role handling was refactored in 5.14 and down to 5.4
>>> it differs even more, so backports to earlier kernels definitely needs
>>> more care.
>>>
>>> My plan would be to limit backporting of the whole series to kernels
>>> down to 5.15 (maybe 5.10 if it turns out to be doable) and for kernels
>>> before that only without patch 6. That would leave out the problematic
>>> change but still give us the benefits of dropping the needless mmu
>>> unloads for only toggling CR0.WP in the VM. This already helps us a lot!
>>
>> To back up the "helps us a lot" with some numbers, here are the results
>> I got from running the 'ssdd 10 50000' micro-benchmark on the backports
>> I did, running on a grsecurity L1 VM (host is a vanilla kernel, as
>> stated below; runtime in seconds, lower is better):
>>
>>                           legacy     TDP    shadow
>>     Linux v5.4.240          -        8.87s   56.8s
>>     + patches               -        5.84s   55.4s
> 
> I believe "legacy" and "TDP" are flip-flopped, the TDP MMU does't exist in v5.4.

Well, whatever the meaning of "TDP" is in v5.4 -- 'tdp_enabled'
completely mirrors the value of 'enable_ept' / 'npt_enabled'. But yeah,
it probably means what "legacy" is for newer kernels.

> 
>>     Linux v5.10.177       10.37s    88.7s    69.7s
>>     + patches              4.88s     4.92s   70.1s
>>
>>     Linux v5.15.106        9.94s    66.1s    64.9s
>>     + patches              4.81s     4.79s   64.6s
>>
>>     Linux v6.1.23          7.65s    8.23s    68.7s
>>     + patches              3.36s    3.36s    69.1s
>>
>>     Linux v6.2.10          7.61s    7.98s    68.6s
>>     + patches              3.37s    3.41s    70.2s
>>
>> I guess we can grossly ignore the shadow MMU numbers, beside noting them
>> to regress from v5.4 to v5.10 (something to investigate?). The backports
>> don't help (much) for shadow MMU setups and the flux in the measurements
>> is likely related to the slab allocations involved.
>>
>> Another unrelated data point is that TDP MMU is really broken for our
>> use case on v5.10 and v5.15 -- it's even slower that shadow paging!
>>
>> OTOH, the backports give nice speed-ups, ranging from ~2.2 times faster
>> for pure EPT (legacy) MMU setups up to 18(!!!) times faster for TDP MMU
>> on v5.10.
> 
> Anyone that's enabling the TDP MMU on v5.10 is on their own, we didn't enable the
> TDP MMU by default until v5.14 for very good reasons.

Fair enough. But the numbers don't look much better for v5.15, so we
still want to fix that performance degradation when using TDP MMU (we
used to have a patch that disables TDP MMU in grsec by default but this,
of course, has no impact on setups making use of a vanilla / distro host
kernel and using grsec in the guest VM).

> 
>> I backported the whole series down to v5.10 but left out the CR0.WP
>> guest owning patch+fix for v5.4 as the code base is too different to get
>> all the nuances right, as Sean already hinted. However, even this
>> limited backport provides a big performance fix for our use case!
> 
> As a compromise of sorts, I propose that we disable the TDP MMU by default on v5.15,
> and backport these fixes to v6.1.  v5.15 and earlier won't get "ludicrous speed", but
> I think that's perfectly acceptable since KVM has had the suboptimal behavior
> literally since EPT/NPT support was first added.

The issue only started to get really bad when TDP MMU was enabled by
default in 5.14. That's why we reverted that change in grsecurity right
away. Integrating that change upstream will get us back to the pre-5.14
performance numbers but why not do better and fix the underlying bug by
backporting this series?

> 
> I'm comfortable backporting to v6.1 as that is recent enough, and there weren't
> substantial MMU changes between v6.1 and v6.3 in this area.  I.e. I have a decent
> level of confidence that we aren't overlooking some subtle dependency.

Agreed, the backports down to v6.1 were trivial.

> 
> For v5.15, I am less confident in the safety of a backport, and more importantly,
> I think we should disable the TDP MMU by default to mitigate the underlying flaw
> that makes the 18x speedup possible.  That flaw is that KVM can end up freeing and
> rebuilding TDP MMU roots every time CR0.WP is toggled or a vCPU transitions to/from
> SMM.

For v5.15 a few more commits are needed to ensure all requirements are
met, like no guest owned CR4 bits overlap with KVM's MMU role. But
that's manageable, IMHO, as some parts already went into previous stable
updates, making the missing net diff for the backport +6 -5 lines.

> 
> We mitigated the CR0.WP case between v5.15 and v6.1[1], which is why v6.1 doesn't
> exhibit the same pain as v5.10, but Jeremi discovered that the SMM case badly affects
> KVM-on-HyperV[2], e.g. when lauching KVM guests using WSL.  I posted a fix[3] to
> finally resolve the underlying bug, but as Jeremi discovered[4], backporting the fix
> to v5.15 is going to be gnarly, to say the least.  It'll be far worse than backporting
> these CR0.WP patches, and maybe even infeasible without a large scale rework (no thanks).

So disabling TDP MMU for v5.15 seems to mitigate both performance
degradation, Jeremi's and ours. However, I'd like to get the extra
speedup still. As I wrote, I already did the backports and it wasn't all
that bad in the end. I just had to read and map the code of older
kernels to what newer kernels would do and it's not that far away,
actually. It's the cleanup patches that just make it look a lot a
different, but for the MMU role it's actually not all that different.
It's completely different story for v5.4, sure. But I don't propose to
backport the full series to that kernel either.

> 
> Anyone that will realize meaningful benefits from the TDP MMU is all but guaranteed
> to be rolling their own kernels, i.e. can do the backports themselves if they want
> to use a v5.15 based kernel.  The big selling point of the TDP MMU is that it scales
> better to hundreds of vCPUs, particularly when live migrating such VMs.  I highly
> doubt that anyone running a stock kernel is running 100+ vCPU VMs, let alone trying
> to live migrate them.

I'll post the backports I did and maybe can convince you as well that
it's not all that bad ;) But I see your proposal patch [3] got merged in
the meantime and is cc:stable. Might make sense to re-do my benchmarks
after it got applied to the older kernels.

Thanks,
Mathias

> 
> [1] https://lkml.kernel.org/r/20220209170020.1775368-1-pbonzini%40redhat.com
> [2] https://lore.kernel.org/all/959c5bce-beb5-b463-7158-33fc4a4f910c@linux.microsoft.com
> [3] https://lore.kernel.org/all/20230413231251.1481410-1-seanjc@google.com
> [4] https://lore.kernel.org/all/7332d846-fada-eb5c-6068-18ff267bd37f@linux.microsoft.com
