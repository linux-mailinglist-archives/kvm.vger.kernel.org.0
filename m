Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCDD4D1B37
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 16:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347713AbiCHPAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 10:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347715AbiCHPAo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 10:00:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D7F484D9D1
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 06:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646751587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jzr7Tjg5k88wWs3L1tmpG2SvYl/v6vmFVG1ptblPx8I=;
        b=XtXIj8R4Ceo9NHsp+i5Fm4zULvywisxT+aPNMsrlVDuthizTQpe6maNyO4EDxA9Y/3zzxO
        eWpR7VEDW68ekOh7sdVJFVPsG9ben4PpsZJ0veZZnN7iKtWVSQHKL+PI+Swgc+SqhDl/ac
        9Ut4g4GqGqxTXlpFCwNrP7dOGPR99o0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-u9aTCdBLN9yv2yTDaasmIA-1; Tue, 08 Mar 2022 09:59:46 -0500
X-MC-Unique: u9aTCdBLN9yv2yTDaasmIA-1
Received: by mail-ej1-f69.google.com with SMTP id k21-20020a1709063e1500b006d0777c06d6so8823042eji.1
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 06:59:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jzr7Tjg5k88wWs3L1tmpG2SvYl/v6vmFVG1ptblPx8I=;
        b=SftynOJxevDIpwwJ42zlxnfvy6KZLaCnSKu2CfDEcn9oKv3jB8rq9AerSzGeDpC/ZQ
         YvlkKNJgqEk8bKarDhHRT3TRbvW/LALbCmPQZJSFoK0jqeJq0jAWSKnKlq3tNUh4FKPg
         o0OrCVI0MlguVSPJa0KFllFHp5e4winmA96CMaeXz6BWNXLOoqSMXCjhyEcijj3JnYs0
         a8cIjMbDNy+m+XMZK1ggYLX6O2eG9VI6NbOclPKvWn+05vxenotclS/K0dT3PYPuhWKY
         93ePA6mLtfR79YToV/GTmjcaPlCyvDSllig35wYqAcKLWpLBG77GLsnVlshu0bIsBNep
         kdkQ==
X-Gm-Message-State: AOAM531podU4WDldHVyHMPPGnwv7TXpB9NqPgp4V8rxVb+DJOwMmcztq
        y94e4CbT98Nf8BNKeSadVZh3DhBOX/OqrfetbBq1leNvfzezHheNh4PN8jiv7dbsJpVKkF9DX79
        PRrkCpPQ2pd4A
X-Received: by 2002:a05:6402:3492:b0:416:378e:c388 with SMTP id v18-20020a056402349200b00416378ec388mr12076687edc.241.1646751583789;
        Tue, 08 Mar 2022 06:59:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzAIf05Z7tePcNG41qY85oWlbcDBl5BHMOBUho0m22NnwAN8Sw/cvL0grij/RNa6laYNY8PdA==
X-Received: by 2002:a05:6402:3492:b0:416:378e:c388 with SMTP id v18-20020a056402349200b00416378ec388mr12076675edc.241.1646751583607;
        Tue, 08 Mar 2022 06:59:43 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id m10-20020a056402510a00b00415eee901c0sm7069093edd.61.2022.03.08.06.59.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 06:59:42 -0800 (PST)
Message-ID: <76606ce7-6bbf-dc92-af2c-ee3e54169ecd@redhat.com>
Date:   Tue, 8 Mar 2022 15:59:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 0/1] KVM: Dirty quota-based throttling
Content-Language: en-US
To:     Shivam Kumar <shivam.kumar1@nutanix.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, agraf@csgraf.de
References: <20211220055722.204341-1-shivam.kumar1@nutanix.com>
 <f05cc9a6-f15b-77f8-7fad-72049648d16c@nutanix.com>
 <YdR9TSVgalKEfPIQ@google.com>
 <652f9222-45a8-ca89-a16b-0a12456e2afc@nutanix.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <652f9222-45a8-ca89-a16b-0a12456e2afc@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/22 16:39, Shivam Kumar wrote:
> 
>> On Mon, Jan 03, 2022, Shivam Kumar wrote:
>>> I would be grateful if I could receive some feedback on the dirty 
>>> quota v2
>>> patchset.
>>    'Twas the week before Christmas, when all through the list,
>>    not a reviewer was stirring, not even a twit.
>>
>> There's a reason I got into programming and not literature.  Anyways, 
>> your patch
>> is in the review queue, it'll just be a few days/weeks. :-)
> Thank you so much Sean for the update!

Hi, are you going to send v3?

Paolo

