Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56F3210CD7
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 15:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731313AbgGAN4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 09:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731306AbgGAN4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 09:56:03 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B1AC08C5C1;
        Wed,  1 Jul 2020 06:56:03 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b16so11020470pfi.13;
        Wed, 01 Jul 2020 06:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=CtpcT4F0x/vH3K8XgUUubiGKpLg7PGJcUE/N+fY4+ls=;
        b=uTPt0QnA0CxUOssH2kjl1N857N6vOD/mU186sk8PQ0iOS8eAyOoLjp6AWLzwP/r4pC
         jX3T1EFAmnFbCGn/UUqYekGPm5wyrFrb5XdGvaxgQ9Fd/T2AIj0ofmbCPIxfSnldZUQA
         EgwhnWcEAeraWxF+F9VGL72SPh7X3/0j2QZl+YCN4wVgY3vx+pdeT4K1Svr82EgqK6n5
         5Px0Z08d9CuuFMFcuGIFU9mZaAMPMB3wzEUWBLf/c7T/x2KBai5/coHIUasRSZxKSD04
         coxUqdV7jyEo2DBoHZHNMCBFnxaqSxgzHLaKivz+tzdPl7w9crCqLdD2HlUrqbupZrLA
         ZqIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=CtpcT4F0x/vH3K8XgUUubiGKpLg7PGJcUE/N+fY4+ls=;
        b=Vh5Cl2HQdsuU+RteJ9XEJROl/RVqJi2WDFrjoajgAYmdunZAM+pla/Z9RDwNtgD8tz
         xhfZ7B0i8PaIO+XG++j37c9X1d5SuffEWMyYzm58khWjrNRQjWVpf4MfbEkTO+liSmr9
         BGStAf734lAUcQU5jqDFPLqVH+msGLxCO/jOL0S3ReySpYGjCL/L63iJM2rlMA1emmmq
         OBYcdSQKctVeHNIIrj+eXnZzoFZxtaF6Po+dSO324LBKN6JltxAfNPwIu9qY/inZtB4W
         TXpSFXQehjZxJgaCo5R7dmfslnfn4UfSYCz4yLMG1hc6e5Fn7CeA/aPU3zYKgz3Ol6OS
         OQ6g==
X-Gm-Message-State: AOAM532465nOXfswUrzg8bx8QAz1IwX2eSELfDbSaNWrLMqNBOn5BJYb
        TI7ek/tPKOhNumqFRUNM67w=
X-Google-Smtp-Source: ABdhPJwj81dRqAkE8wSM1wFBnpnLAMGN61+sBVJjcVY9PajkoyLDohl8H1nn1Rtr8dgU4NVNeHfq9Q==
X-Received: by 2002:a65:400a:: with SMTP id f10mr16752443pgp.197.1593611762972;
        Wed, 01 Jul 2020 06:56:02 -0700 (PDT)
Received: from [127.0.0.1] ([47.244.202.117])
        by smtp.gmail.com with ESMTPSA id r8sm6052573pfg.147.2020.07.01.06.55.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Jul 2020 06:56:02 -0700 (PDT)
From:   hackapple <2538082724huangjinhai@gmail.com>
X-Google-Original-From: hackapple <2538082724@qq.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
Message-Id: <182DECB4-C515-4249-AFF9-D275A25B3D0B@qq.com>
Date:   Wed, 1 Jul 2020 21:55:56 +0800
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, graf@amazon.de,
        hpa@zytor.com, jan.setjeeilers@oracle.com, jwadams@google.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        liran.alon@oracle.com, luto@kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, peterz@infradead.org, rkrcmar@redhat.com,
        rppt@linux.vnet.ibm.com, tglx@linutronix.de, x86@kernel.org
To:     alexandre.chartre@oracle.com
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

How about performance when running kvm example or isolate other kernel data?

