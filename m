Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46B24DE800
	for <lists+kvm@lfdr.de>; Sat, 19 Mar 2022 14:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242974AbiCSNB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Mar 2022 09:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242971AbiCSNB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Mar 2022 09:01:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98DB52493E1
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 06:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647694835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4k8ijoIj0sDG51+05imWcknHS7+grv3qe/MN5OZW7Co=;
        b=GsfgVqnegHT/GvJ5l0Ggh+pIK+YoCrSJFbtFRREF0i9OCyF37bAXal9JWAUFg028bpI7sG
        nIMMtfIr5tSeWgIaGNmk81UKqC1L6J6vLYrcEZOLnHOKPdJNHj7U8fYeEZFnZtUcCAw4wX
        Z5C+A2IDKt3giBl2vih4VqWttS8BU2s=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-p4Wudz50PFG-D36Z9X9QIQ-1; Sat, 19 Mar 2022 09:00:34 -0400
X-MC-Unique: p4Wudz50PFG-D36Z9X9QIQ-1
Received: by mail-ed1-f70.google.com with SMTP id d28-20020a50f69c000000b00419125c67f4so2258977edn.17
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 06:00:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=4k8ijoIj0sDG51+05imWcknHS7+grv3qe/MN5OZW7Co=;
        b=rIIHRP7wTleXA1eKMOWx8woi6u/nxsvcPP7MsgHhZBctkbn2ExQpvpxp7Q5h65l5qz
         LI/QXXcBH9NDcZJoK9teC/mW1TlgvMfNFGVLJhlp1pVCCl8cHBhDIqHv0liSfv3AXYm5
         +XNLAsYxQeO8fDKuuZHrDCAtNsxKrDtGfmjKb/+okhFWzOpPGADTC7UgyAfNEG5BNCPr
         TWU205QrjRuNVLaLpdGR8/WAqU2304EJd7YzuBH8tu3FFzpQaHK/l8Rp00xuVSaSywlS
         xY7ISUZ9Qu0EWp0pL9cEQaaAMM/Cee7DDrI3haf3nfegHfzYrbYK8iOFyJPbBGcejQgJ
         tmvg==
X-Gm-Message-State: AOAM533omca770/N2wRqZwSb28pg0LiXkaqNy213v7cjWqi1i9jsms72
        crWoyYY3TV2WzFV0SfHYnoS2ncmW+P+hpU7X5uvyMW+eholPeSUgwLpF3Tzsmb4RhjdjWKJ8fky
        gcguJcG7neQbl
X-Received: by 2002:a50:9d0f:0:b0:416:95a3:1611 with SMTP id v15-20020a509d0f000000b0041695a31611mr14420081ede.77.1647694832789;
        Sat, 19 Mar 2022 06:00:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCsddMck5OPf8hgGtmIgVQMkqUFETJbgD3/Zn+JucpADtFvB9gPhRgGe4kw5HgHQ0uvotczQ==
X-Received: by 2002:a50:9d0f:0:b0:416:95a3:1611 with SMTP id v15-20020a509d0f000000b0041695a31611mr14420061ede.77.1647694832497;
        Sat, 19 Mar 2022 06:00:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id da19-20020a056402177300b00413583e0996sm5469713edb.14.2022.03.19.06.00.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Mar 2022 06:00:31 -0700 (PDT)
Message-ID: <3548e754-28ae-f6c4-5d4c-c316ae6fbbb0@redhat.com>
Date:   Sat, 19 Mar 2022 14:00:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
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
 <a6011bed-79b4-72ab-843c-315bf3fcf51e@redhat.com>
In-Reply-To: <a6011bed-79b4-72ab-843c-315bf3fcf51e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/19/22 12:54, Paolo Bonzini wrote:
> On 3/19/22 09:08, David Woodhouse wrote:
>> If a basic API requires this much documentation, my instinct is to
>> *fix* it with fire first, then document what's left.
> I agree, but you're missing all the improvements that went in together 
> with the offset API in order to enable the ugly algorithm.
> 
>> A userspace-friendly API for migration would be more like KVM on the
>> source host giving me { TIME_OF_DAY, TSC } and then all I have to do on
>> the destination host (after providing the TSC frequency) is give it
>> precisely the same data.
> 
> Again I agree but it would have to be {hostTimeOfDay, hostTSC, 
> hostTSCFrequency, guestTimeOfDay}.

Ah, I guess you meant {hostTimeOfDay, hostTSC} _plus_ the constant 
{guestTSCScale, guestTSCOffset, guestTimeOfDayOffset}.  That would work, 
and in that case it wouldn't even be KVM returning that host information.

In fact {hostTimeOfDay, hostTSC, hostTSCFrequency, guestTimeOfDay} is 
not enough, you also need the guestTSCFrequency and guestTSC (or 
equivalently the scale/offset pair).

Paolo

