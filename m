Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B782544E61
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 16:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244405AbiFIOIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 10:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243828AbiFIOIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 10:08:47 -0400
Received: from smarthost1.sentex.ca (smarthost1.sentex.ca [IPv6:2607:f3e0:0:1::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CC643ADB
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 07:08:45 -0700 (PDT)
Received: from pyroxene2a.sentex.ca (pyroxene19.sentex.ca [199.212.134.19])
        by smarthost1.sentex.ca (8.16.1/8.16.1) with ESMTPS id 259E8gAh043935
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 9 Jun 2022 10:08:42 -0400 (EDT)
        (envelope-from mike@sentex.net)
Received: from [IPV6:2607:f3e0:0:4:a049:6d67:75bb:b6ac] ([IPv6:2607:f3e0:0:4:a049:6d67:75bb:b6ac])
        by pyroxene2a.sentex.ca (8.16.1/8.15.2) with ESMTPS id 259E8gmP020347
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Thu, 9 Jun 2022 10:08:42 -0400 (EDT)
        (envelope-from mike@sentex.net)
Message-ID: <28563857-e860-ab70-75ba-6cd5b2e1c23a@sentex.net>
Date:   Thu, 9 Jun 2022 10:08:43 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Guest migration between different Ryzen CPU generations
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <48353e0d-e771-8a97-21d4-c65ff3bc4192@sentex.net>
 <0fa08623-22c3-d6c6-d068-4582bd8d2424@redhat.com>
From:   mike tancsa <mike@sentex.net>
In-Reply-To: <0fa08623-22c3-d6c6-d068-4582bd8d2424@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/9/2022 10:01 AM, Paolo Bonzini wrote:
> On 5/31/22 19:00, mike tancsa wrote:
>> On Ubuntu 22 LTS, with the original kernel from release day, I can 
>> migrate VMs back and forth between a 3700x and a 5800x without issue
>> On Ubuntu 22 LTS with everything up to date as of mid May 2022, I can 
>> migrate from the 3700X to the 5800x without issue. But going from the 
>> 5800x to the 3700x results in a migrated VM that either crashes 
>> inside the VM or has the CPU pegged at 100% spinning its wheels with 
>> the guest frozen and needing a hard reset. This is with --live or 
>> without and with --unsafe or without. The crash / hang happens once 
>> the VM is fully migrated with the sender thinking it was successfully 
>> sent and the receiver thinking it successfully arrived in.
>> On stock Ubuntu 22 (5.15.0-33-generic) I can migrate back and forth 
>> to Ubuntu 20 as long as the hardware / cpu is identical (in this 
>> case, 3700x)
>> On Ubuntu 22 LTS with everything up to date as of mid May 2022 with 
>> 5.18.0-051800-generic #202205222030 SMP PREEMPT_DYNAMIC Sun May 22. I 
>> can migrate VMs back and forth that have as its CPU def EPYC or 
>> EPYC-IBPB. If the def (in my one test case anyways) is Nehalem then I 
>> get a frozen VM on migration back to the 3700X.
> Hi, this is probably related to the patch at 
> https://www.spinics.net/lists/stable/msg538630.html, which needs a 
> backport to 5.15 however.
>
> Note that using Intel definitions on AMD or vice versa is not going to 
> always work, though in this case it seems to be a regression.
>
Thanks for the followup. Forgive the naive question, but I am new to 
linux. Do patches like this typically get picked up by distributions 
like Ubuntu, or would I need open a bug report to flag this for them so 
its included in their updates ?

     ---Mike


> Paolo
>
