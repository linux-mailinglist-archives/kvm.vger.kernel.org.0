Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75107BB363
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 10:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbjJFIkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 04:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjJFIki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 04:40:38 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454E693;
        Fri,  6 Oct 2023 01:40:37 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-3226cc3e324so1808804f8f.3;
        Fri, 06 Oct 2023 01:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696581635; x=1697186435; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kZ4MK+LkUJUvJ9sOD+5swyDMzW1yvSnPTDNFzgSqerQ=;
        b=VOwHGX7+VmXLASn6+Ex7rQJODbc+9axJvBOtqbkRjWfafDSS0O+XR9tQgirHb0sPjy
         j9WCw49OmfX1TxvWMUfvimuM52aaGX2XDRcZqdIk2zvpLQSwUfJaymQtHJ4c0j9Bu3i3
         nco8GDQ3eUSLLFWM3pM6MItS9DQvi9kq1752r4PzgkHjwWuZz7iSG5LH2X8rdfciC1xR
         Dcl12ZBIScv6wk1RBJbOS/PxKoV0WNFUE8mVpeWX+nN9aCIOVFgmse1CAmRlqvP2+vMu
         GfrGRlrNwTJ6PLeZ9UybI1uOI+Zc/P+/fipnv37H9CsaWb8VNpesuqpkgfGfT9NNbDfG
         3Aqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696581635; x=1697186435;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kZ4MK+LkUJUvJ9sOD+5swyDMzW1yvSnPTDNFzgSqerQ=;
        b=VvAaA6C5iKMDtB3DUkNVOwoCSoxlyEOf6j9007Q1epYafQ8e6++GiIL4Dq4JFBmBiE
         OCQNuFjyHCjbLLSpGQaTuh+mucEE2F62HqOUSXzq9q1bnGF5YDB4GjWteDZITuljyQEA
         LA2kH4q+vZbHZK0Fi/GE9dOC516Y37zucZZFa+O0fl2Zswdu9xnnyf8yfvoB4EMWgpbQ
         qmn8sKRiTunXP0AwKT5L7oMofEglqhcKoy0PnEA6qXzz9BMoBgjhdeYojTtQ6I1rrU/m
         TPrYbEtRH17bgLjBG2mjJ9Dnh37I5+OxihThqTjRtv1FCZDLA0DftbIRwBjEWiZpbbQW
         JfVg==
X-Gm-Message-State: AOJu0Ywz2nZZvaPJ5+eTotbiSwoz+B7GPyiKGcue7iRjy7UrWSpa2YFf
        kndoe90IWKfVg5I5/XXoBtA=
X-Google-Smtp-Source: AGHT+IHKzg/RutaGqFE7+lnwGxtMzQuPBBi4dTMFMTwM0BnvULCnVlPxXKi/8i2gxoXBWGxxo5an0w==
X-Received: by 2002:a05:6000:14e:b0:320:a19:7f87 with SMTP id r14-20020a056000014e00b003200a197f87mr6404855wrx.18.1696581635415;
        Fri, 06 Oct 2023 01:40:35 -0700 (PDT)
Received: from [192.168.11.19] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a9-20020adfe5c9000000b003142e438e8csm1121559wrn.26.2023.10.06.01.40.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Oct 2023 01:40:35 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <f0524bd4-11a1-415e-b2f8-645241a63afe@xen.org>
Date:   Fri, 6 Oct 2023 09:40:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2] KVM: x86/xen: ignore the VCPU_SSHOTTMR_future flag
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Durrant <pdurrant@amazon.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
References: <20231004174628.2073263-1-paul@xen.org>
 <ZR2vTN618U0UgtIA@google.com> <5fc0fbfe-72e8-44bf-bad2-92513f299832@xen.org>
 <ZR9nYw53O21y0VYM@google.com>
Organization: Xen Project
In-Reply-To: <ZR9nYw53O21y0VYM@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/10/2023 02:48, Sean Christopherson wrote:
> On Thu, Oct 05, 2023, Paul Durrant wrote:
>> On 04/10/2023 19:30, Sean Christopherson wrote:
>>> On Wed, Oct 04, 2023, Paul Durrant wrote:
>>>> ---
>>>> Cc: David Woodhouse <dwmw2@infradead.org>
>>>> Cc: Sean Christopherson <seanjc@google.com>
>>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>> Cc: Ingo Molnar <mingo@redhat.com>
>>>> Cc: Borislav Petkov <bp@alien8.de>
>>>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>>>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>>>> Cc: x86@kernel.org
>>>
>>> If you're going to manually Cc folks, put the Cc's in the changelog proper so that
>>> there's a record of who was Cc'd on the patch.
>>>
>>
>> FTR, the basic list was generated:
>>
>> ./scripts/get_maintainer.pl --no-rolestats
>> 0001-KVM-xen-ignore-the-VCPU_SSHOTTMR_future-flag.patch | while read line;
>> do echo Cc: $line; done
>>
>> and then lightly hacked put x86 at the end and remove my own name... so not
>> really manual.
>> Also not entirely sure why you'd want the Cc list making it into the actual
>> commit.
> 
> It's useful for Cc's that *don't* come from get_maintainers, as it provides a
> record in the commit of who was Cc'd on a patch.
> 
> E.g. if someone encounters an issue with a commit, the Cc records provide additional
> contacts that might be able to help sort things out.
> 
> Or if a maintainer further up the stream has questions or concerns about a pull
> request, they can use the Cc list to grab the right audience for a discussion,
> or be more confident in merging the request because the maintainer knows that the
> "right" people at least saw the patch.
> 
> Lore links provide much of that functionality, but following a link is almost
> always slower, and some maintainers are allergic to web browsers :-)
> 

Ok... makes sense.

>>> Or even better, just use scripts/get_maintainers.pl and only manually Cc people
>>> when necessary.
>>
>> I guess this must be some other way of using get_maintainers.pl that you are
>> expecting?
> 
> Ah, I was just assuming that you were handcoding the Cc "list", but it sounds
> like you're piping the results into each patch.  That's fine, just a bit noisy
> and uncommon.
> 
> FWIW, my scripts gather the To/Cc for all patches in a series, and then use the
> results for the entire series, e.g.
> 
>    git send-email --confirm=always --suppress-cc=all $to $bcc $cc ...
> 
> That way everyone that gets sent mail gets all patches in a series.  Most
> contributors, myself included, don't like to receive bits and pieces of a series,
> e.g. it makes doing quick triage/reviews annoying, especially if the patches I
> didn't receive weren't sent to any of the mailing list to which I'm subscribed.

Ok, I'll send stuff that way in future. Thanks,

   Paul

