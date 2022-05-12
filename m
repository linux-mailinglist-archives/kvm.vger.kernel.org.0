Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4316152518B
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 17:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356089AbiELPrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 11:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355820AbiELPrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 11:47:36 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF86654686;
        Thu, 12 May 2022 08:47:33 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ks9so11103858ejb.2;
        Thu, 12 May 2022 08:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OdL976vLL7ORf9B/iqPYmPEs4gjTIH2k/LdAlNEcN30=;
        b=faJwwC1MuTVmgL5xPNbDL3fF+QN4wmHB4NNbkZt62y2o4pqJqp2UFekOtyVET/OMgY
         LPSu+Nyw3BwVZK8KY+rzl4M1T5PT1xootFOJLvXCLNdaIclcXB4eIIKzg8nzasrYr2rE
         ellZLdfWFIzPe8q5XlAifZB4W5MkSL0F+2C+u3q0uv9HWE3Vk47nVRAIREIqiQqIBKeY
         7zfhW8CQValihInV8dAdfdK6OtGo8PrvTYzp0a1JxsaAmSH50A/dImQGfQ6wLc55BqpR
         eiVpSxZt7dBpmYWKomGedWkAHvt5zilfvcJ5MjMX6+7n7PaM93htSUtmVJH3lb4AJ/Zy
         ppIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OdL976vLL7ORf9B/iqPYmPEs4gjTIH2k/LdAlNEcN30=;
        b=BG6+FW7s8dcNNjGxTl+fgkxkLz6n2F2ccvZtOVyZCtwrI9gOUroLUo2+eu/p2ykJB7
         rrtYZy9j/Zf6mULhYVdHEnyq4yyJHe5O0dS7KzsBDgSjI2JkX9r581K4QtyS+oa4or9D
         t8VsJta2tZcXqaKJV9Ui8lx92yL5JSHdBiQ7os4cC9FFohP7awNkI1Wcg2qhirkuGP50
         /cA3W9TCBF+1xzbExhZDZzSFv4BPfrGoI0SysaumxP4BCfFwOAQrQCXaeWMlRrkgISpP
         FrErlpAQ9gOJnegZAzddlRHs6te7FP65fJGHD2qCHYh8rGKMtvwzltEQgKsT6ou63332
         VQQg==
X-Gm-Message-State: AOAM533aKMnQArAKBHNHzEd01NT1IzX4N7YdKayoBwp0dWdzr3swoUzu
        +4ob0lKPZtF+zAXfp+A95pI=
X-Google-Smtp-Source: ABdhPJyN9CavbcLznjgRYCTgBCrVJSgDYbe/sPG7azObZJbJ0mG7qKI5CAjKXKGVKbxb3iOc4yhf+g==
X-Received: by 2002:a17:906:f857:b0:6f3:a331:c043 with SMTP id ks23-20020a170906f85700b006f3a331c043mr482360ejb.246.1652370452116;
        Thu, 12 May 2022 08:47:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id g7-20020a170906c18700b006f3ef214e58sm2268677ejz.190.2022.05.12.08.47.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 08:47:31 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <8a1db30d-5cfb-6b43-c162-576e24d5dc3f@redhat.com>
Date:   Thu, 12 May 2022 17:47:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3] KVM: x86/mmu: Update number of zapped pages even if
 page list is stable
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
References: <20220511145122.3133334-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220511145122.3133334-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/11/22 16:51, Sean Christopherson wrote:
>   - Collect David's review.
>   - "Rebase".  The v2 patch still applies cleanly, but Paolo apparently has
>     a filter configured to ignore all emails related to the v2 submission.

I cannot find it at all on patchew.org in fact.  Queued this one now.

Paolo
