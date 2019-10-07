Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F259CED12
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 21:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbfJGT6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 15:58:21 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:34200 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbfJGT6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 15:58:21 -0400
Received: by mail-pf1-f181.google.com with SMTP id b128so9359337pfa.1
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2019 12:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qs0ZOJY4NxjG+9EbB4+zf1yeZqRra6zPOpb/xLk+Vl8=;
        b=gR6oZdT0IjUy7knIUDpdpMFYkwRXC9LJ36GdTZiSBvs+SVzdwiy5UzIjXjWUYwW/qs
         L4Mc6DWkhufe7IEc5ucJl7cEqkqZppeYPuFhqUvB6UVIZvzC+laPeme6Qcjnq5cgdstI
         6njfzrdsWtyQjHTSx841dgoPPUoOYS7MWzgNB3YGubc5gngMwzDkr8JofYYm1LWrZOCL
         afrHCFuaA1vBas3s+WosXt2wlNuc+bzADHjDWtwaO+DTWIx0F04mV5KlSwvxdTy4u3sT
         PcR1HCXYfvBMKuRmpU5H3CXWff8JjCOUIcrZwz9+ioJu/HOzbyPVlTOZWkspuRvSIaFs
         z+YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qs0ZOJY4NxjG+9EbB4+zf1yeZqRra6zPOpb/xLk+Vl8=;
        b=bNmiGl5kUlwJ9U8uNrXd2nhyF9uXHT6PenJkumBEZlvelZHKtisXvB+82/89CpUEEq
         LUdQkr7tEWw9kScYYNWHzdA3zI/HOazt2CjWlTLO28MeHEb3puTw6BOQ3wEQE7WwZtTK
         giAkY/sMSsvhjxUmXn02rONWj6HtpRtTNCeqvU8hXiyw2McvAiueYBUwTkaNYwEcietO
         HFAitCXssSPULtaGCbYq4TWRGTf6+gga6k9V7jVXIam5KFZEO9lIir0Q6grgIqf9ATrw
         C1LLL9FCEeRCZnMo3ZP5UQ/8OkszA9vaRS/uvIecZG5FGmX8UcxJfDXw48zdvc9IRA7q
         WltA==
X-Gm-Message-State: APjAAAVejw9E0URkpWIWmSdZpSXOMWB5V5epwHrzMqNa1aq9D51UDJkG
        aNN0tP3WWx5a+9aPw1K6Nm8=
X-Google-Smtp-Source: APXvYqzVH92xgsTZGrDciZk1T9W6PVYCMDcLQi9VSmVxBceTnRU9a3C/GoFvxn6NQ2qm0njWWkxiTg==
X-Received: by 2002:a62:e21a:: with SMTP id a26mr11861pfi.80.1570478298857;
        Mon, 07 Oct 2019 12:58:18 -0700 (PDT)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id y7sm15490291pfn.142.2019.10.07.12.58.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 12:58:18 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: Determining whether LVT_CMCI is supported
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <2CF61715-CA79-4578-BD09-A0B6E2B2222F@gmail.com>
Date:   Mon, 7 Oct 2019 12:58:16 -0700
Cc:     Marc Orr <marcorr@google.com>, kvm list <kvm@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <223C58D0-2AF4-4397-BDFF-3DD134E5B52A@gmail.com>
References: <2CF61715-CA79-4578-BD09-A0B6E2B2222F@gmail.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Oct 2, 2019, at 6:22 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
> 
> Hello Sean,
> 
> Sorry for keep bothering you, but I am a bit stuck with fixing one
> kvm-unit-tests that fails on Skylake bare-metal.
> 
> The reason for the failure is that I assumed that APIC_CMCI (MSR 0x82f)
> support is reported in MSR_IA32_MCG_CAP[10].
> 
> However, on my machine, I get:  MSR_IA32_MCG_CAP (0x179) = 0x7000816
> 
> And although MSR_IA32_MCG_CAP[10] is clear, APIC_CMCI is still accessible.
> 
> Is there a way to determine whether LVT_CMCI is supported on a CPU?

Sean, anyone?

Otherwise, I would just disable this test on bare-metal, which might hide
bugs.
