Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D79489B23
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 15:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbiAJOSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 09:18:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53713 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233643AbiAJOSb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 09:18:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641824310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MyDFUtiAGsgsScU+rj6Lzzf5+dTQR7JO2CzhcJOaowg=;
        b=N7xsINfifI0Alr6zEIAwj71AOGEiwKFmz25TUQmiy0UygZB6zaFUztaHSvyOtYHkk36wtN
        nhy+2JNzg0I0SHlGno/gtSw/2CbHXEeDcc35V5Yb7zToyVVdVkPBlKHC+fG94RUrgnBmTM
        +VqYsxL1gMSIr+nNeC8zsb77M88s4QM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-snPDuVI0OIeVVAQEY2mU6Q-1; Mon, 10 Jan 2022 09:18:29 -0500
X-MC-Unique: snPDuVI0OIeVVAQEY2mU6Q-1
Received: by mail-ed1-f72.google.com with SMTP id y18-20020a056402271200b003fa16a5debcso10220212edd.14
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 06:18:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MyDFUtiAGsgsScU+rj6Lzzf5+dTQR7JO2CzhcJOaowg=;
        b=Oml9z/n9cxvk514bTM1DjCswWCIWR6XyM+fVR/MG3R8R7IVRbmpPmamhbUrGYlCTfV
         bEt85PeWSzPBg2xpRISSeAkyn3+dVahdRpBHHYNVF/9mEtPeldhN2ZMgdjrBAi4L1y7f
         xidN5WtSV3TiURtr+U6rq/Oj3d1kj9t5IBFq8X4XR/3GOzzScrTA1qXMnclnMG7crQgS
         +YEG/Qbzf20Drq1+JvD/y8lGZCN7MxE/dfVn2fhcu3patYWUlfc2w4PliS3dwnmqEMEw
         cDQvfdcaw0AyNImXBzr4VGGd7liM9hR9xWwUOG3NppCtvIjENhPueQwIRAQhqvJku9JV
         0Tkg==
X-Gm-Message-State: AOAM531hRe3EheXaQm1XSdzM1F3t+7GFZfMaS2WJ2epFRt8c2UcXgQ2E
        EjoDCa0mIQBjj4ns6o/Xae0TRqLpbpXwUqXVDwD1Ke/resnuirNPckKOLq4EpQrw2Cm69ijgBhd
        ZEMsMxNrfI2DM
X-Received: by 2002:a17:906:8490:: with SMTP id m16mr10796311ejx.504.1641824308102;
        Mon, 10 Jan 2022 06:18:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxrJfxt8rkBnco5dvB92y/phpCALDwxjDXLd9vNGVpjjfWL50MFHy+ZOPOOCekX0ogxMmOWnQ==
X-Received: by 2002:a17:906:8490:: with SMTP id m16mr10796287ejx.504.1641824307860;
        Mon, 10 Jan 2022 06:18:27 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id o1sm2477166ejm.210.2022.01.10.06.18.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 06:18:27 -0800 (PST)
Message-ID: <761a554a-d13f-f1fb-4faf-ca7ed28d4d3a@redhat.com>
Date:   Mon, 10 Jan 2022 15:18:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v6 05/21] x86/fpu: Make XFD initialization in
 __fpstate_reset() a function argument
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
 <20220107185512.25321-6-pbonzini@redhat.com> <YdiX5y4KxQ7GY7xn@zn.tnic>
 <BN9PR11MB527688406C0BDCF093C718858C509@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Ydvz0g+Bdys5JyS9@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ydvz0g+Bdys5JyS9@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/10/22 09:52, Borislav Petkov wrote:
> On Mon, Jan 10, 2022 at 05:15:44AM +0000, Tian, Kevin wrote:
>> Thanks for pointing it out! Actually this is one area which we didn't get
>> a clear answer from 'submitting-patches.rst'
> 
> Are you sure? I see
> 
> "Any further SoBs (Signed-off-by:'s) following the author's SoB are from
> people handling and transporting the patch, but were not involved in its
> development. SoB chains should reflect the **real** route a patch took
> as it was propagated to the maintainers and ultimately to Linus, with
> the first SoB entry signalling primary authorship of a single author."

Say a patch went A->B->C->A->D and all of {A,B,C} were involved in the 
development at different times.  The above text says "any further SoBs 
are from people not involved in its development", in other words it 
doesn't cover the case of multiple people handling different versions of 
a patch submission.

The only clear thing from the text would be "do not remove/move the 
author's Signed-off-by", but apart from that it's wild wild west and 
there are contradictions everywhere.

For example:

1) checkpatch.pl wants "Co-developed-by" to be immediately followed by 
"Signed-off-by".  Should we imply that all SoB entries preceded by 
Co-developed-by do not exactly reflect the route that the patch took 
(since there could be multiple back and forth)?

2) if the author sends the patches but has co-developers, should they be 
first (because they're the author) or last (because they're the one 
actually sending the patch out)?


Any consistent rules that I could come up with are too baroque to be 
practical:

1) a sequence consisting of {SoB,Co-developed-by,SoB} does not 
necessarily reflect a chain from the first signoff to the second signoff

2) if you are a maintainer committing a patch so that it will go to 
Linus, just add your SoB line.

3) if you pick up someone else's branch or posted series, and you are 
not in the existing SoB chain, you must add a Co-developed-by and SoB 
line for yourself.  Do not use the document the changes in brackets: 
that is only done by the maintainers when they make changes and do not 
repost for review.

The maintainers must already have a bad case of Stockholm syndrome for 
not having automated this kind of routine check, but it would be even 
worse if we were to inflict this on the developers.  In the end, IMHO 
the real rules that matter are:

- there should be a SoB line for the author

- the submitter must always have the last SoB line

- SoB lines shall never be removed

- maintainers should prefer merge commits when moving commits from one 
tree to the other

- merge commits should have a SoB line too

Everything else, including the existence of Co-developed-by lines, is an 
unnecessary complication.

Paolo

