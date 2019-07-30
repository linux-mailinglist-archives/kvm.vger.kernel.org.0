Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E38DE7A189
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 09:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbfG3HAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 03:00:18 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:33650 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728673AbfG3HAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 03:00:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564470017; x=1596006017;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=6yX5wo1SMWNdvTLLZ4kGJt2N9VK/hrcTYoYK9A/+LG0=;
  b=qCC56rGfb1GOhqj48wIpcB7sZhk4KihSK9MTfvEp4DFTJEm2nKB7JirY
   A+ZT5D31S3JZrrz+EkZCVHLwlptNJEuuBuf2Y8gt6ujxhHfEBgfd0kYzT
   YtSJSCg8ZKrffzcFhCYR/Ypng5ZsNGsAOeWicop4Hp3AH4bW+ZJU3ahQF
   mdoPxa4an3Nb5VBjO18optwTy4UF5Ov89QJtFr6XX5vlCq9u43g25cNQZ
   y7FzJ62tgcEzn/USDmNVTClyhdsrf22mKpLEQ1juQG8/nq0k7jnbSZacR
   ZNo3AEvB13qAnFPxE0NDoEygqhfAS24kW0gRu8z5gLAxDhW5ALz5Rh1sH
   Q==;
IronPort-SDR: WE4K9dwGMNU8/J3rFFhy5c6WITPTrKQEqjVGrtN1IGqAuuL/7ohk8zj0dt6dcpQh0sB4PH72OD
 cqDlj0qEUw3ny1uCApcwOQ5YGN/JqqISbJNaM8uGn1ENVmZgoyCN0cr8nvY2j2cFgrugc/nr3I
 L63FfpfyeMyYXNkYrcU6OYrlTHtTxfx+TYVAl5s+vQ374hC3QXSpHt4N8U62D60xRJvc97ijn4
 zzHlFtyJIHQH/ueUpfSccwARTZ62b3/UsfIeI+9eIqb0v1Dspg6xWRtW3G/vf45rHaiHQOzZ9/
 q7A=
X-IronPort-AV: E=Sophos;i="5.64,325,1559491200"; 
   d="scan'208";a="114456997"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jul 2019 15:00:17 +0800
IronPort-SDR: /QWI+yFcZ0rmgrhKzyaUKAxecyhx6rlLS9zDK+jVfV2Ur085+At+ld04SJShKi9+Xb+zxh0S7D
 pEsv13dWfGT7hPlN1hLRf14IIujJoCGQbhUaKylgYuTPgVtDUAr7qi/C4J3JKvtAg5yMdXBzwA
 O9X5cEHbbf20DW/l6g9nojv0yFoJ6fo4xgm7Avbdmv1/53PXeTWOFKyWV+bnFGZ+l3UZAUs4+W
 7ILDLn24sZOja9ptQ+hpUyO5fkstDY0Zfg1aOim4RDGMKxa+s1NI9IGM30lkLxQdkM1nLLULdS
 6WOdx8q6kT8rQ3S7M9JYhsx+
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP; 29 Jul 2019 23:58:20 -0700
IronPort-SDR: PCZNYufBvpE+xMfNsmNx/TlpTDwjyYVkZ4LeoaSFcTvmUrDclh9vepYujrd287BTmiIXHyFXpE
 H6Ff+uC+5bOpDPx7+TzSF+LmE85iKM7xEHaitIoCAqKGwNPrvMiyD2YFvyXyUSLiIzCKyM1HJU
 cE60SHu5w4JUL7ne/ZpqwyqVc37bNuM/Ba5fo8CVnLgDiYzsZLk1h/pK8gjIVnnRbAwm67UT/1
 ds4vVY+wFANqtZOJCkKS4VJ95y2fx4ACxcqAknOYi3LHM7PSBDYqH3u99x3HWGa7TJvyDWr/zk
 Wfw=
Received: from unknown (HELO [10.225.104.231]) ([10.225.104.231])
  by uls-op-cesaip01.wdc.com with ESMTP; 30 Jul 2019 00:00:16 -0700
Subject: Re: [RFC PATCH 13/16] RISC-V: KVM: Add timer functionality
To:     Andreas Schwab <schwab@suse.de>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "anup@brainfault.org" <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "palmer@sifive.com" <palmer@sifive.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <20190729115544.17895-1-anup.patel@wdc.com>
 <20190729115544.17895-14-anup.patel@wdc.com> <mvmpnlsc39p.fsf@suse.de>
 <d26a4582fad27d0f475cf8bca4d3e6c49987d37d.camel@wdc.com>
 <mvma7cwaubk.fsf@suse.de>
From:   Atish Patra <atish.patra@wdc.com>
Message-ID: <ce9e762d-5b70-0092-d21c-3d9be8fa2a69@wdc.com>
Date:   Tue, 30 Jul 2019 00:00:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <mvma7cwaubk.fsf@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/29/19 11:51 PM, Andreas Schwab wrote:
> On Jul 29 2019, Atish Patra <Atish.Patra@wdc.com> wrote:
> 
>> Strange. We never saw this error.
> 
> It is part of CONFIG_KERNEL_HEADER_TEST.  Everyone developing a driver
> should enable it.
> 
>> #include <linux/types.h>
>>
>> Can you try it at your end and confirm please ?
> 
> Confirmed.
> 

Thanks. I will update the patch in v2.

> Andreas.
> 


-- 
Regards,
Atish
