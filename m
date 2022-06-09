Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08369544E51
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 16:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238960AbiFIOBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 10:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbiFIOBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 10:01:45 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A58C21E24
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 07:01:43 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id y19so47682141ejq.6
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 07:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QRShvbstHeC9lEE+ew+EW0zDtUnb73H372nphW0FCy8=;
        b=BIv1WxeKMdUSnma1KeL3SuvuMmxsrYUUL9DlG6Wo4y8xbrc0nnoCJpwb+tmW9acy7L
         KBtGtRPqkYZdWK1cCPrX1pqkOzPCeVL9s4Id3H+ES7KTVwh2aKG0tvUoR8toN8cv1sEG
         +Eu51y4ykAfQI0wZ80DeF52TlrIxAAdhbypnGpmFjOXpQbbYmzredVAT8SmSfMSJIXhp
         wjSJgUCWCdifOoIgIqrbh1LBcoddftuywNeLUakT0y4ACsVSRlfQwSLNf2cjviuHnJTP
         SEbLQSzqtKnuSsVZHbuJyiZk5me84pgZTCdnKe/MYTMRkdKeaXT/xdKk8VOnRzb2vf5T
         F8TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QRShvbstHeC9lEE+ew+EW0zDtUnb73H372nphW0FCy8=;
        b=xC1GqI97nCi9aio87DexM781cv66NB58otaJstk3bqRrPx12h1hXK9xaZdYQuk9DlM
         7CwZASaIpv9L6hzZ6r1JJJT5zH3qScSK/1uhIQwkRHH/1+OrUk3R4DGYSsy6PgebQKcp
         L3+b6F64eYh77LBgH8j+6AKV5w6VJ+DqBbNEVnVXKPolda9htQggorV9ai3uF63LJebF
         k0wypXBMLXHbEkyrr4dtXQXiwdYAfJBQfXVMoDEmlhciA/RNRAaffOc0RtEHBUayxC9M
         YiFZnurvYkXZrEg7tXLov8NdhsOY4+l3/1SVQryN4IU8w+ZNjIrxh/6rboxi0uj06F2B
         UPPA==
X-Gm-Message-State: AOAM5326ukkEvTDry++zbGsxWeCfi/fL6SyU39HtLTqF0U5/egOCqUfL
        UybUwKqayazg85xEPrdxjZCgghLCKKA=
X-Google-Smtp-Source: ABdhPJxf91zmiKS4f4NeWsxgcMEU4nceApWZzHl2EIGLPEkWGPjZ9Lj2n8bLArMqd+orOXSwYuVXJA==
X-Received: by 2002:a17:906:f51:b0:6fe:cf1c:cdbf with SMTP id h17-20020a1709060f5100b006fecf1ccdbfmr35734092ejj.695.1654783301697;
        Thu, 09 Jun 2022 07:01:41 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id k16-20020a1709061c1000b00705cdfec71esm10537621ejg.7.2022.06.09.07.01.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 07:01:41 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <0fa08623-22c3-d6c6-d068-4582bd8d2424@redhat.com>
Date:   Thu, 9 Jun 2022 16:01:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: Guest migration between different Ryzen CPU generations
Content-Language: en-US
To:     mike tancsa <mike@sentex.net>, kvm@vger.kernel.org
References: <48353e0d-e771-8a97-21d4-c65ff3bc4192@sentex.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <48353e0d-e771-8a97-21d4-c65ff3bc4192@sentex.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/22 19:00, mike tancsa wrote:
> On Ubuntu 22 LTS, with the original kernel from release day, I can 
> migrate VMs back and forth between a 3700x and a 5800x without issue
> On Ubuntu 22 LTS with everything up to date as of mid May 2022, I can 
> migrate from the 3700X to the 5800x without issue. But going from the 
> 5800x to the 3700x results in a migrated VM that either crashes inside 
> the VM or has the CPU pegged at 100% spinning its wheels with the guest 
> frozen and needing a hard reset. This is with --live or without and with 
> --unsafe or without. The crash / hang happens once the VM is fully 
> migrated with the sender thinking it was successfully sent and the 
> receiver thinking it successfully arrived in.
> On stock Ubuntu 22 (5.15.0-33-generic) I can migrate back and forth to 
> Ubuntu 20 as long as the hardware / cpu is identical (in this case, 3700x)
> On Ubuntu 22 LTS with everything up to date as of mid May 2022 with 
> 5.18.0-051800-generic #202205222030 SMP PREEMPT_DYNAMIC Sun May 22. I 
> can migrate VMs back and forth that have as its CPU def EPYC or 
> EPYC-IBPB. If the def (in my one test case anyways) is Nehalem then I 
> get a frozen VM on migration back to the 3700X.
Hi, this is probably related to the patch at 
https://www.spinics.net/lists/stable/msg538630.html, which needs a 
backport to 5.15 however.

Note that using Intel definitions on AMD or vice versa is not going to 
always work, though in this case it seems to be a regression.

Paolo
