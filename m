Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119C85F6B2C
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 18:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiJFQFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 12:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiJFQFT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 12:05:19 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1CA264A7
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 09:05:14 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id x1so2123382plv.5
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 09:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cT6Wml9S1ICPcfPS0gzA03K8f/z1T5TSf1gdKkI6GrY=;
        b=Bp92U1a12wrSrCN9TakLM1KsCP4mI+BX3Am5EJvY2R+1A2ZMaA4ihmfLh9pdPDLu6K
         ABtqz9R9lmqKBcDnOctULtWW3z+Umi+Yg6GLUO/Ey1OT/ufu65mB9p6pfxhA8MD3etl+
         8tdZcabNRtX1YjQZaHOsr97vn6L4CyoY2REyCqjv+EZwC5Y+6QhF/F+WCzw2i+ReD400
         /2r7tY6sA+36XckYmNlG3QntgybebM88hvKLmKxtXsxFnpfdzW1ki9202UtvsavGfmSD
         V1YlrHVthyJ1HqPC8IQOkx9PHw2/AFukj8XYPvdAaN3FID+BhTO1i8ia8iDR5ERcozFN
         zNAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cT6Wml9S1ICPcfPS0gzA03K8f/z1T5TSf1gdKkI6GrY=;
        b=NlgvnPZPINQIKjTRu9XF7BQl2jLV+7MBUIrKUrB/wnaaeBNKMUmrUtPaRR/AIohrqv
         OZX1jDodNTELyT7VS4QFZu9o+h9Y8z26smuGrwIWqhiGoASXCTeCb+/muc5kbc0zuXZs
         n5P8vLZUfG83ghH9jkFuTjg+OlQw2pEO8gamOreyIMcM+ZwMxwKcRcdLURGd/ffcv3zb
         tT7PHTOssydmmOwRkU8bsqX2Wh6HUKTbmPLmpBMjLBrRHr2xOvDVK2DKr/BmZst4N2tx
         ZMKudYTCrrWhNyKNgCjfKbdLbkFeqsgKKnDX3F+tAoo2LiLUjYYjZk7GDujD9EBst5+1
         UFsg==
X-Gm-Message-State: ACrzQf2LYgSHrgNm2tSQIeZILufCXHjsr9c2XNlTFzU+YwDNJeRYTbeP
        pMkVZsePbVjsHiSYGmUz44Msx8/dG/KeJA==
X-Google-Smtp-Source: AMsMyM4SmWRAr8XIm92LZSVbrEy0CSbefHJrXRAmUIrxWSnA7JGJuaa/fksJceEGgrAgYbsYlwTi1A==
X-Received: by 2002:a17:902:8bc3:b0:178:8563:8e42 with SMTP id r3-20020a1709028bc300b0017885638e42mr205632plo.0.1665072314400;
        Thu, 06 Oct 2022 09:05:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n4-20020a170903110400b001753654d9c5sm12674322plh.95.2022.10.06.09.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 09:05:13 -0700 (PDT)
Date:   Thu, 6 Oct 2022 16:05:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     ToddAndMargo <ToddAndMargo@zoho.com>
Cc:     virt-tools-list@redhat.com, kvm@vger.kernel.org
Subject: Re: Windows-11 22H2 upgrade problems
Message-ID: <Yz78tnoBaj53Q1U8@google.com>
References: <6e10d10b-8e64-0d4b-7bbf-f0478743b664@zoho.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e10d10b-8e64-0d4b-7bbf-f0478743b664@zoho.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 05, 2022, ToddAndMargo wrote:
> Hi All,
> 
> Fedora 36
> qemu-kvm-6.2.0-15.fc36.x86_64
> Windows 11 Pro
> 
> Any of you guys having troubles upgrading Windows-11
> build 21H2 to 22H2?
> 
> I am upgrading from the ISO:
>    https://www.microsoft.com/en-us/software-download
> /windows11
> 
> using the US English version:
>    Win11_22H2_English_x64.iso
> 
> The install goes all the way through the process and
> when It does its final reboot, it throws the "Installation
> failed in SAFE_OS phase with an error during BOOT
> operation 0xC1900101 0x20017".

There's a decent chance you're hitting known bugs in KVM's SMM emulation that can
cause Windows 11 with Secure Boot to crash.  If you can build+install a custom
host kernel, the in-progress fixes[*] are healthy enough that you can try them out
locally.

[*] https://lore.kernel.org/all/20220803155011.43721-1-mlevitsk@redhat.com
