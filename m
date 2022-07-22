Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A80B57D80D
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 03:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbiGVBlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 21:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiGVBk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 21:40:59 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9918E11153;
        Thu, 21 Jul 2022 18:40:58 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id f3-20020a17090ac28300b001f22d62bfbcso2535976pjt.0;
        Thu, 21 Jul 2022 18:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wQ4PwxJdfeRuNFlBgfKXQzk/YsoiF4IpRVdTPSkrj58=;
        b=hq4fXVwKlhrxu5/HkzmMTJXI58duVtf5bcwzWDTb+EtRHfvCIAr1DVRQgfUnlAcV05
         RI+gw00avBdTD5q1pS8nF1EhK8X+KWIizO5aAgKpCu0VdStgIj556c3G0cd19iCFdFeb
         JcUd3UOQbRQeuDe+7DduZqongYVr6JmfA5oK1LKlmBweXYHGH81iOG/HzIXkMHROh4VX
         X8RHYTZgL3ISwOpXG7C9xrHrViEL/bNuOb4dQTZLj5AccQrg9AWwDMWys1q5b8/9raS4
         4zeiok5CSjOQug+vIsMLy7El5CoV20N2jgbvOqybBL9fQNW66gcx1wNIyqVrJ83/KpIL
         zRUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wQ4PwxJdfeRuNFlBgfKXQzk/YsoiF4IpRVdTPSkrj58=;
        b=XwEDPRCEUU8tGZLKWgIU+FmwjNveAW2LaTUGPLafaLXv12J+q7UXQ78KouRylDWiGT
         0945s4PuNoOLNc8ZzW8nz+LZKKq5+qyeBnmqzU9KF2g3jUsJs5myUgSqrKpQbDYfQh/e
         hRLGAsNC+MYKFxUcApJ3Y9zgbQMLoVIu6CdLsf2Qg03oVu6rYxQSR8tzmSSae6aoCflK
         rIIvlgUUglYTPABvud8/JPNaAgac+8M+DVjq4N5papEozKbisEbxk+xiU26v/qFfpQVs
         fENeZm/7FxN/uledd45GwbUWEJolIh/hvXdNcn+JwxFxUbHLrEfkeXatxADyL704hLOF
         FBaA==
X-Gm-Message-State: AJIora9z+UTSQV1Rx1vW78TdzjgUccXqQIGOU+WwyL110OjmkXBCU61n
        lkGpSrgGyT1zZ8N85c4DvXc=
X-Google-Smtp-Source: AGRyM1ttGkNHj4rBoCrfvrWDPH8ttiNUx2pwkiSRVGCKVMLCgCOu/R4Bw2sjCT07NlZoEM0kf3MkOw==
X-Received: by 2002:a17:90b:3a88:b0:1f2:199d:2ceb with SMTP id om8-20020a17090b3a8800b001f2199d2cebmr1351864pjb.196.1658454057976;
        Thu, 21 Jul 2022 18:40:57 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-36.three.co.id. [116.206.28.36])
        by smtp.gmail.com with ESMTPSA id x27-20020aa7941b000000b005251f4596f0sm2434829pfo.107.2022.07.21.18.40.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 18:40:57 -0700 (PDT)
Message-ID: <f918aa10-2d75-815f-d75a-52ef3ffa7776@gmail.com>
Date:   Fri, 22 Jul 2022 08:40:50 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [GIT PULL 25/42] Documentation: kvm: extend KVM_S390_ZPCI_OP
 subheading underline
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jonathan Corbet <corbet@lwn.net>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
 <20220721161302.156182-26-imbrenda@linux.ibm.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220721161302.156182-26-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/21/22 23:12, Claudio Imbrenda wrote:
> From: Bagas Sanjaya <bagasdotme@gmail.com>
> 
> Stephen Rothwell reported the htmldocs warning:
> 
> Documentation/virt/kvm/api.rst:5959: WARNING: Title underline too short.
> 
> 4.137 KVM_S390_ZPCI_OP
> --------------------
> 
> The warning is due to subheading underline on KVM_S390_ZPCI_OP section is
> short of 2 dashes.
> 
> Extend the underline to fix the warning.
> 

Thanks for picking this up!

Acked-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
