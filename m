Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6883F37E9C
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 22:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfFFUTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 16:19:09 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53004 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbfFFUTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 16:19:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so1188394wms.2
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 13:19:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fAkfn85/lqdX0osdVxNuElygntohyc34l0gKSlhr3ag=;
        b=dOtow6cDzBj6YgrmlveurGD56muEHVL6LS7q2kOLUE18Cmq4EnTXsLlqi0zL9W1wOm
         +I+zEQxnKAwYqMzfY5ZQJJGMN3O/RMTBPAu2kmB8f5XCuWnP6oxC4AfM6CrPS+tm9gFD
         i5Qre0NqrYTE1Vy7OEtS977kYrssEshb7QozQT0apcKDLDlrNmU1Bip40+J0Loczg7tZ
         GIkcOBiGBh/Pg8Rtl4J4xvVqXWXD7WJpQPvJazGuw6ar+eVFj5fvUi15lW+3rT3G3y+3
         ogv3n1rympTG1Zk/b/VixnKj5HdK4YN6/a0ecyQpPAy9hzurTj4I7DldBz1s5HDYd7pl
         w5LQ==
X-Gm-Message-State: APjAAAWxCvL7HTXLZYVs3TDCpk3fpgpzNwgmZ1HSFztlbmfvBiU4hi9s
        CwC0gO0qDjLORPsb0AqbSRatBHS8PFo=
X-Google-Smtp-Source: APXvYqz48mChkyOODV0ajnbXZEGl5Ke1m19drYd50JUK+efjQXEu/HUD/f9LmnXacpx2Wf2aaiFrEA==
X-Received: by 2002:a1c:dc45:: with SMTP id t66mr1201738wmg.63.1559852345364;
        Thu, 06 Jun 2019 13:19:05 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id c129sm2700570wma.27.2019.06.06.13.19.04
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 13:19:04 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Rename prepare_vmcs02_*_full to
 prepare_vmcs02_*_extra
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1559834652-105872-1-git-send-email-pbonzini@redhat.com>
 <20190606184117.GJ23169@linux.intel.com>
 <89dd5d66-0d37-ea41-3f6d-72d5a8a9815d@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cd3f30e2-32ed-4bba-0456-f7ab7e24d792@redhat.com>
Date:   Thu, 6 Jun 2019 22:19:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <89dd5d66-0d37-ea41-3f6d-72d5a8a9815d@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/06/19 21:19, Krish Sadhukhan wrote:
> 
> The big chunk of the work in this function is done via
> prepare_vmcs02_constant_state(). It seems cleaner to get rid of
> prepare_vmcs02_early_full(), call prepare_vmcs02_constant_state()
> directly from prepare_vmcs02_early() and move the three vmcs_write16()
> calls to prepare_vmcs02_early().
> 

This is just a mechanical search and replace, you can send a patch on
top to inline it in the caller.

Paolo
