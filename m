Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E755017EC
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 18:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245320AbiDNPwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 11:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351924AbiDNP2b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 11:28:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 452DC633D
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 08:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649948970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xPC1Y2muJZRmIAmU2vFNWQJ1nI7VdYew8mF3Uluw4dw=;
        b=KA2a5AjgT0lz2EUagTdD3LQCJGAS/rvzsylBIsjf+jy+h6I5Il0cGxFj/1Wtu+PWclrdUG
        9iP3Rd255Llbh/zS7s1S5mdjdWgIkN0P7TCnf1Da1P7A5c7vBNfYZRHNHW80q6p0W8ngyd
        +JzZXEhuov1hwO3NJfDBVhKPhc/Zq8w=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-C6xhWxnAODOzVWjkC_hFGw-1; Thu, 14 Apr 2022 11:09:28 -0400
X-MC-Unique: C6xhWxnAODOzVWjkC_hFGw-1
Received: by mail-wm1-f70.google.com with SMTP id o6-20020a05600c510600b0038ec5f6d217so2360007wms.8
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 08:09:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xPC1Y2muJZRmIAmU2vFNWQJ1nI7VdYew8mF3Uluw4dw=;
        b=CpaaRRnZeNkF6ph7xWW2iYc59bBDBYb1zqcReMBjxmltLmUVAJFQszwXRp2tKjSVsm
         ueW0oos2CkAOiv06X3zNK/FSCoVbNrRgnMMT73J9w/gt0ITx+2HhY1XjCznVA6cIMSNg
         GOFamWnxxrbvcimjoSYLThA/9xjooFWFgo4HdrZeRpEbUi+RBjZw/qQGglBZFxxeu8t9
         pSS/h9SAyBrucGZQ5fOTCzM+n68a9XSdbfw3IxR1DMVmJvUljtCbYyW8X22g3783wgA2
         vh1PSTdKN0ZXeeqRzA7J1D6NoyhkaQ1U2tfzeuX46CEWp4+2FReZlH59NedW1BHCe/XZ
         hYOQ==
X-Gm-Message-State: AOAM533ipP93hcng8Fp9QRajSsxG66zNLgbabXH/BI6Y96nV12ddy8Ys
        qseEVX+Vv8zxRmGfAhDvcvMj/v+MPNktzNB76DXd28AxdONtQXDgyXtyGKG7mnPLv7C0evPefSL
        JaACBumGSLLA8
X-Received: by 2002:a05:600c:4e8b:b0:38c:90cf:1158 with SMTP id f11-20020a05600c4e8b00b0038c90cf1158mr4095896wmq.107.1649948967322;
        Thu, 14 Apr 2022 08:09:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8bw6bCudEh07zRGiT3FUd7Y1RFhksv7ICEXTx+ik3SJbSbdOfPUPm4HcCtqPBbR6/zoS29g==
X-Received: by 2002:a05:600c:4e8b:b0:38c:90cf:1158 with SMTP id f11-20020a05600c4e8b00b0038c90cf1158mr4095873wmq.107.1649948967044;
        Thu, 14 Apr 2022 08:09:27 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id m3-20020a5d6243000000b001e33760776fsm2001356wrv.10.2022.04.14.08.09.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Apr 2022 08:09:26 -0700 (PDT)
Message-ID: <bf10e7c9-0654-1608-1085-0e8359aaa391@redhat.com>
Date:   Thu, 14 Apr 2022 17:09:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 00/22] https://www.spinics.net/lists/kvm/msg267878.html
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220414074000.31438-1-pbonzini@redhat.com>
 <2939c0cb-8e0c-7de4-7143-2df303bbb542@redhat.com>
 <Ylg3m4qZ23wO+5oo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ylg3m4qZ23wO+5oo@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/14/22 17:02, Sean Christopherson wrote:
>> Uh-oh, wrong subject.  Should be "KVM MMU refactoring part 2: role changes".
>>
>> Supersedes:<20220221162243.683208-1-pbonzini@redhat.com>
>
> Still Spinics huh?  I thought you were using b4 these days?:-)

I use Patchew for tracking and either b4 or Patchew for application, but 
sometimes a certain search engine has different preferences.

Paolo

> KVM Forum 2019 - Reports of my Bloat Have Been Greatly Exaggerated - Paolo Bonzini, Red Hat, Inc.
> 
> KVM Forum 2022 - Reports of my Fossilization Have Been Greatly Understated - Paolo Bonzini, Red Hat, Inc.
> 

