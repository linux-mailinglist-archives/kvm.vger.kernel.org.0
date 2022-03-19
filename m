Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9884DE7BE
	for <lists+kvm@lfdr.de>; Sat, 19 Mar 2022 12:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239774AbiCSLze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Mar 2022 07:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiCSLzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Mar 2022 07:55:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1157126934E
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 04:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647690852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xGDExNkB901wVENmG6aAGf8Liob/EXK2QBZ7AQLBlfY=;
        b=H188dShAp6xOk6GokEdTMrp1XQ95Ff1HJFLdWS0vV4e4qwK+OSLUGvm0UWiRHJiKN/Pjov
        mCnmFRUX0VYu+VeXLKnkdCDuX40+Woac5QMQIKNh/RBiH0bX0papycYwOSufvhDkWwLxEo
        w3uxrL4S3AtD+ZVaWpup6NkGYezt2Fo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-8XhYQXipOtSdF302pWyVqg-1; Sat, 19 Mar 2022 07:54:10 -0400
X-MC-Unique: 8XhYQXipOtSdF302pWyVqg-1
Received: by mail-ej1-f70.google.com with SMTP id ml20-20020a170906cc1400b006df8c9357efso3879449ejb.21
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 04:54:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xGDExNkB901wVENmG6aAGf8Liob/EXK2QBZ7AQLBlfY=;
        b=chdtq7Ko/EX/8+8f2gu6XtOi+gK5yPyAvjMg1WQaWc/bRFrByryW+M57pp71aSnE10
         hVNEevoMNon19r/HmPevKFySm0/rCmzV+32/LOtr1Wpxxunto0q/YD6tJzdX58G/cjSV
         3oQANFbUVQuH1Nn9vpxI3nDkhyk70lC1v8gH1De0U94srp1CeUeg7gkohplJlUUfA7AE
         XBPeIkhNXPZN8u3nyyyUn8i9HAL+uqUsq0D57/XVJFY6an3aVDh+xXtPrm2kgHfbbq3O
         g7KjHX+jYAqhuosYcEDTH8OMVga+kzWVFjaQ2OBg3UmxRpdNpU21uS7cmqw6aSTbzhug
         ZjdA==
X-Gm-Message-State: AOAM530qEUA7qlPibaHVpu0YgKMIC+M3eNFCL+hdZoWCZOZJUgKxsrq/
        R3ug6k7yOIV/idBvopuxB88RnQ7tDt6Oo3yb212jSQwdeSHQoPEOZHhd69QOGSXtL6mBtDBc6n+
        d8R8+DE2LPQAl
X-Received: by 2002:a05:6402:5303:b0:416:13c0:3e75 with SMTP id eo3-20020a056402530300b0041613c03e75mr14097404edb.299.1647690848891;
        Sat, 19 Mar 2022 04:54:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyhmEe11dTHFFcUOBs5qEUJasvOMbJ3vEjqBVqAP7vZYVIuCMqXQwSeL77Kj9TjLFwSulFow==
X-Received: by 2002:a05:6402:5303:b0:416:13c0:3e75 with SMTP id eo3-20020a056402530300b0041613c03e75mr14097386edb.299.1647690848633;
        Sat, 19 Mar 2022 04:54:08 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id m13-20020a17090672cd00b006df86017b61sm4192207ejl.105.2022.03.19.04.54.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Mar 2022 04:54:08 -0700 (PDT)
Message-ID: <a6011bed-79b4-72ab-843c-315bf3fcf51e@redhat.com>
Date:   Sat, 19 Mar 2022 12:54:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20220316045308.2313184-1-oupton@google.com>
 <34ccef81-fe54-a3fc-0ba9-06189b2c1d33@redhat.com>
 <YjTRyssYQhbxeNHA@google.com>
 <0bff64ae-0420-2f69-10ba-78b9c5ac7b81@redhat.com>
 <YjWNfQThS4URRMZC@google.com>
 <e48bc11a5c4b0864616686cb1365dfb4c11b5b61.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <e48bc11a5c4b0864616686cb1365dfb4c11b5b61.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/19/22 09:08, David Woodhouse wrote:
> If a basic API requires this much documentation, my instinct is to
> *fix* it with fire first, then document what's left.
I agree, but you're missing all the improvements that went in together 
with the offset API in order to enable the ugly algorithm.

> A userspace-friendly API for migration would be more like KVM on the
> source host giving me { TIME_OF_DAY, TSC } and then all I have to do on
> the destination host (after providing the TSC frequency) is give it
> precisely the same data.

Again I agree but it would have to be {hostTimeOfDay, hostTSC, 
hostTSCFrequency, guestTimeOfDay}.

> For migration between hosts, the offset-based API doesn't seem to be
> much of an improvement over what we had before.

The improvement is that KVM now provides a consistent {hostTimeOfDay, 
hostTSC, guestTimeOfDay} triple, so the "get" part is already okay.  I 
agree that the "set" leaves a substantial amount of work to the guest, 
because *using* that information is left to userspace rather than being 
done in KVM.  But at least it is correct.

So we only lack a way to retrieve hostTSCFrequency to have an ugly but 
fully correct source-side API.  Then we can add a new destination-side 
ioctl (possibly an extension of KVM_SET_CLOCK?) that takes a 
{sourceTimeOfDay, sourceTSC, sourceTSCFrequency, guestTimeOfDay} tuple 
and relieves userspace from having to do the math.

Paolo

