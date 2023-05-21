Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDBB70AC33
	for <lists+kvm@lfdr.de>; Sun, 21 May 2023 05:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjEUDos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 May 2023 23:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjEUDom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 May 2023 23:44:42 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0678111F;
        Sat, 20 May 2023 20:44:42 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-53404873a19so3271704a12.3;
        Sat, 20 May 2023 20:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684640681; x=1687232681;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SL4uL+0ooOhf/aDssPqwcUbkWmE/VBQrEPhJXPQmD9Q=;
        b=LgmNhRQIwE3dic7rdCSZ8MDMFZwK6qjah/wGqQVO4p9EQTMjkOkwDx2uIM3IjSVyK1
         lr0YTszVU0t7RtThakEMJe5C7J4DT4C962wSIwDCrPM2J7Aeah6VT7FVipdqFZ7reGaO
         7WojsEUjNXsuY+AKgXV19p9Wlyy+U5cpAHMQ1YCz/pAjd7v9AV/ln0M2QAEpIPhUI5Dn
         gn/aYoDXzTGgrnJycEVjREvbtx3Hs1b/0jpl8l/WbkBOz9gRHMSBHJ2Z1zJYlTXCCT3x
         VQzHBuO04NySJ+lzlY1i81OA2goO8k0SGsiUtsQFh8f4yTLC2X38AA8p0llwAvDwBmQr
         wNdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684640681; x=1687232681;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SL4uL+0ooOhf/aDssPqwcUbkWmE/VBQrEPhJXPQmD9Q=;
        b=Fvdt2kMxHxNCg5bed8uzVYdwM3qCMtXFToYLWKqQA8s05ITZp1wAu8RlvsAakrOKQl
         HqrF9TB1QgSIZhLdbomxB8VbUklXmxueJhQUlUEvGHbu5+opYxdjelGux8oUUoEeEWnh
         7S80AhJCf+PMYzfYHD3z5OonVWII/d35asp9R1gH2TSP5aMIBZC/4+O2XU5OHr4Go4xC
         vOmvsJEot4Ba8IALDOP5fXkB9MHQ0KHwZaohusmsLZvwTm68WNctDO/hyVQ3keD3E1qs
         y5xf8+dDfxKtAnu217g5sIa8CFkbHy0ntSsFIZrBnWgtJySZI7KZHSt/MXJznaLx99gn
         mrRQ==
X-Gm-Message-State: AC+VfDyfSgljQGBDo2ijlRcCW3LSQIc+9bJJrTpSUY3Nvep6U4BWqgI/
        9LzqBRYxn6Jne5JD3W0c7ys=
X-Google-Smtp-Source: ACHHUZ6wrnaCoBJWBg685ejuyEA0YzgDIIWVmsY0LmElLhB9TuADWoGJGorSCrOlj5JDMF6oqAFGJQ==
X-Received: by 2002:a17:902:da91:b0:1ac:7543:bcdf with SMTP id j17-20020a170902da9100b001ac7543bcdfmr8204176plx.31.1684640681094;
        Sat, 20 May 2023 20:44:41 -0700 (PDT)
Received: from [172.27.232.67] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id i3-20020a170902c94300b001ae59169f05sm2220305pla.182.2023.05.20.20.44.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 May 2023 20:44:40 -0700 (PDT)
Message-ID: <3f09e751-33fd-7d60-78cd-6857d113e8bd@gmail.com>
Date:   Sun, 21 May 2023 11:44:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 5/6] KVM: x86: Keep a per-VM MTRR state
Content-Language: en-US
To:     Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <20230509135300.1855-1-yan.y.zhao@intel.com>
From:   Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <20230509135300.1855-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/9/2023 9:53 PM, Yan Zhao wrote:
> Keep a per-VM MTRR state and point it to the MTRR state of vCPU 0.
> 
> This is a preparation patch for KVM to reference a per-VM guest MTRR
> to decide memory type of EPT leaf entries when noncoherent DMA is present.
> 
> Though each vCPU has its own MTRR state, MTRR states should be
> consistent across each VM, which is demanded as in Intel's SDM
> "In a multiprocessor system using a processor in the P6 family or a more
> recent family, each processor MUST use the identical MTRR memory map so
> that software will have a consistent view of memory."
> 
> Therefore, when memory type of EPT leaf entry needs to honor guest MTRR,
> a per-VM version of guest MTRR can be referenced.
> 
> Each vCPU still has its own MTRR state field to keep guest rdmsr()
> returning the right value when there's lag of MTRR update for each vCPU.
> 
Can we get rid of per-vCPU MTRR state copies and just have this per-VM 
state only? therefore can simplify implementation and avoid hazard of 
inconsistency among per-VPU MTRR states.

I see in SDM, it notes:
"In multiple processor systems, the operating system must maintain MTRR 
consistency between all the processors in the system (that is, all 
processors must use the same MTRR values). The P6 and more recent processor 
families provide no hardware support for maintaining this consistency."

leaving each vCPU's MTRR is just to fully mimic HW?

