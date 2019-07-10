Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA4F64DF1
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 23:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfGJVPE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 17:15:04 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:49286 "EHLO lizzard.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727287AbfGJVPE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 17:15:04 -0400
Received: from mail1.sbs.de (mail1.sbs.de [192.129.41.35])
        by lizzard.sbs.de (8.15.2/8.15.2) with ESMTPS id x6ALEoUl018512
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 23:14:50 +0200
Received: from [139.22.38.2] ([139.22.38.2])
        by mail1.sbs.de (8.15.2/8.15.2) with ESMTP id x6ALEmqI009125;
        Wed, 10 Jul 2019 23:14:49 +0200
Subject: Re: KVM_SET_NESTED_STATE not yet stable
From:   Jan Kiszka <jan.kiszka@siemens.com>
To:     "Raslan, KarimAllah" <karahmed@amazon.de>,
        "jmattson@google.com" <jmattson@google.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>
References: <9eb4dd9f-65e5-627d-b288-e5fe8ade0963@siemens.com>
 <1562772280.18613.25.camel@amazon.de>
 <f1936ed9-e41b-4d36-50bb-3956434d993c@siemens.com>
 <cfd86643-dbac-3a69-9faf-03eaa8aee6a1@siemens.com>
Message-ID: <9803d517-f52b-66b8-cefc-d5b89e55de75@siemens.com>
Date:   Wed, 10 Jul 2019 23:14:49 +0200
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
In-Reply-To: <cfd86643-dbac-3a69-9faf-03eaa8aee6a1@siemens.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10.07.19 22:31, Jan Kiszka wrote:
> And on a Xeon D-1540, I'm not seeing a crash but a kvm entry failure when
> resetting L1 while running Jailhouse:
> 
> KVM: entry failed, hardware error 0x7
> EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000f61
> ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
> EIP=0000fff0 EFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ES =0000 00000000 0000ffff 00009300
> CS =f000 ffff0000 0000ffff 00a09b00
> SS =0000 00000000 0000ffff 00c09300
> DS =0000 00000000 0000ffff 00009300
> FS =0000 00000000 0000ffff 00009300
> GS =0000 00000000 0000ffff 00009300
> LDT=0000 00000000 0000ffff 00008200
> TR =0000 00000000 0000ffff 00008b00
> GDT=     00000000 0000ffff
> IDT=     00000000 0000ffff
> CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000680
> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
> DR6=00000000ffff0ff0 DR7=0000000000000400
> EFER=0000000000000000
> Code=00 66 89 d8 66 e8 af a1 ff ff 66 83 c4 0c 66 5b 66 5e 66 c3 <ea> 5b e0 00
> f0 30 36 2f 32 33 2f 39 39 00 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 

OK, looks like the feature diff was a red herring: Ralf found a server with even
more features and without a crash, and I found familiar error messages in the
kernel log of that Xeon D:

kvm: vmptrld           (null)/778000000000 failed
kvm: vmclear fail:           (null)/778000000000

Only difference: No crash, just that more graceful entry failure.

Jan

-- 
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux
