Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462BE55177E
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 13:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241969AbiFTLdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 07:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241921AbiFTLdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 07:33:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AA81E15FD4
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 04:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655724811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3PbCQbIK7HmUq+A4wdqW1zRM8TVyI16FcVAtMkTtwns=;
        b=dLgGBXxWqu74ukngw6HQmTnZJd1V3a/ny1dQ8kjEPGOa0igty37kNtk+TOM0LugeBsqRU0
        cXHchhY2CdtvWZ930ph32/tpYvX5lPQu29yIOSR+tqoUmdV5O9JTtjJZSX7QAkhhhdP/TP
        uMWBDDvwKdVnku7ry+mPsTnd4pG1uuk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-RwroeTPNOY26DN9_NsPKcw-1; Mon, 20 Jun 2022 07:33:31 -0400
X-MC-Unique: RwroeTPNOY26DN9_NsPKcw-1
Received: by mail-ed1-f71.google.com with SMTP id h16-20020a05640250d000b0043572a34a61so3760289edb.15
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 04:33:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3PbCQbIK7HmUq+A4wdqW1zRM8TVyI16FcVAtMkTtwns=;
        b=pECZKLIQ3rNNtAgOjF7M9B7rtWT/rXGLQPW2uz1+a0OfqkuJf/JIE3PNKQ48svGKpZ
         WDaZHNp8HXwSSaGpg9QJyo1fJ1Nn5aULeWJ6PNqESV4OfcpnOZH0DHZBSRDRzr2Z6Avs
         MstUufd/6JE+JnEHmT0B2auchrql8VC0OdnfP8kXzp/BEUbBsZUKAfKihKu1dYG08V+x
         dvxxD0gviavT/+x7slxyaMQE8ro6cX1zOCkhBOf2mT0qUr3oczXUeBcxlfs4EUADT/Rq
         iWui/zRFi+hpA0kd4aa9A2SszgalLzpsT02KRTA8LwXkqNnnm5gUydnk1wmIU/udXpUq
         VH7Q==
X-Gm-Message-State: AJIora83uHZwSm7kNLdP8VxCRqPBlUikVYubU0O3JXx7niUmIdCgrX6X
        5+BnGj2zjlmWzpwTtRmOvX6kpi+Rej1sp7f4KhE913z7baWKHtjTGFB7Ks1Heq9oE9IsnGXkOAC
        PddezRC2XHh7D
X-Received: by 2002:aa7:dd85:0:b0:435:64d1:5ba with SMTP id g5-20020aa7dd85000000b0043564d105bamr18660988edv.389.1655724809313;
        Mon, 20 Jun 2022 04:33:29 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tHnk2ocuWxsBwnqq7v2gZTo+b+WJkchX/7ahH1U/LmESuHPgZOhPNyLY8WwvbZRn6F8Jbjtg==
X-Received: by 2002:aa7:dd85:0:b0:435:64d1:5ba with SMTP id g5-20020aa7dd85000000b0043564d105bamr18660949edv.389.1655724809062;
        Mon, 20 Jun 2022 04:33:29 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id z19-20020a056402275300b004319b12371asm10485788edd.47.2022.06.20.04.33.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jun 2022 04:33:27 -0700 (PDT)
Message-ID: <a844abdc-97c3-8e5a-94e7-ea967876f226@redhat.com>
Date:   Mon, 20 Jun 2022 13:33:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: 'WARNING in handle_exception_nmi' bug at
 arch/x86/kvm/vmx/vmx.c:4959
Content-Language: en-US
To:     Dmitry Vyukov <dvyukov@google.com>,
        =?UTF-8?B?5r2Y6auY5a6B?= <pgn@zju.edu.cn>
Cc:     linux-sgx@vger.kernel.org, secalert@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller@googlegroups.com, kangel@zju.edu.cn, 22121145@zju.edu.cn
References: <69ab985c.7d507.18180a4dcd7.Coremail.pgn@zju.edu.cn>
 <CACT4Y+anXSNgCW3jvsm8wPf0LPxW-kCmXTeno4n-BWntpMaZBA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CACT4Y+anXSNgCW3jvsm8wPf0LPxW-kCmXTeno4n-BWntpMaZBA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/20/22 13:24, Dmitry Vyukov wrote:
> On Mon, 20 Jun 2022 at 12:25, 潘高宁 <pgn@zju.edu.cn> wrote:
>>
>> Hello,
>>
>>      This is Xiao Lei, Gaoning Pan and Yongkang Jia from Zhejiang University. We found a 'WARNING in handle_exception_nmi' bug by syzkaller. This flaw allows a malicious user in a local DoS condition. The following program triggers Local DoS at arch/x86/kvm/vmx/vmx.c:4959 in latest release linux-5.18.5, this bug can be reproducible stably by the C reproducer:
> 
> 
> FWIW a similarly-looking issue was reported by syzbot:
> https://syzkaller.appspot.com/bug?id=1b411bfb1739c497a8f0c7f1aa501202726cd01a
> https://lore.kernel.org/all/0000000000000a5eae05d8947adb@google.com/
> 
> Sean said it may be an issue in L0 kernel rather than in the tested kernel:
> https://lore.kernel.org/all/Yqd5upAHNOxD0wrQ@google.com/

Indeed I cannot reproduce these either on bare metal.

Paolo

