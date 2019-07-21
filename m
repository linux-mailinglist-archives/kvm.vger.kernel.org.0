Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67D4B6F469
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2019 19:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfGURlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Jul 2019 13:41:14 -0400
Received: from mout.web.de ([212.227.15.3]:38279 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfGURlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Jul 2019 13:41:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1563730857;
        bh=w9GNqAKd76XzfPzQug3XxCRQvdkACTEm125ytZ6Jm6A=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=U7hBUTnRjVBw5nDVrP5xu2rEHgVBVtMwAj1Z/ob06RjDaQlLcErLq4Qdpc1UwxjnC
         3gyQMp10s+MpU3y4rpFyW08TATYQCVzZcUu44R2O/HRw+0M1xu0aNrbpBjXDiQ6x2Q
         KXk38/TgHd8+Uj96h4o/8eG1tdeyqAbIRoBQMwww=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.55.156]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Lx7OL-1iVFQX3bhJ-016fWE; Sun, 21
 Jul 2019 19:40:56 +0200
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>, kvm <kvm@vger.kernel.org>
Cc:     Jim Mattson <jmattson@google.com>,
        KarimAllah Ahmed <karahmed@amazon.de>
From:   Jan Kiszka <jan.kiszka@web.de>
Subject: nvmx: get/set_nested_state ignores VM_EXIT_INSTRUCTION_LEN
Message-ID: <3299adf3-3979-7718-702f-bab2d9324c69@web.de>
Date:   Sun, 21 Jul 2019 19:40:55 +0200
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:XU/at5aPEU0NgG7iurmztEYin2k/uQJtcrrumnWwAP4QDKheW33
 nW16vM1JTjwXpPoSlRcIyxmNQZgX+XNGMh96MyK4XA792Qh+1wzJwSO/denUIFpeJC0ygGh
 9UWdmO3Nhx/tqwypU/Dv15MSF5u/t9Ls4kovyG4s59odcxxTTeBswos1OPuYno7QxRrsznB
 d1CDKOmoGVVye+o3WjC5w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:NEn6FZAXtoc=:ySMSdxe/wBHb7Vwwfcs2N9
 r6BNwnu5t9/p81c3YVnH/6qE/Bx44nrjbpQgCa1XgfXROem8KiaqiD8iX6DUhtOVsvj7GtKYC
 v/gE5kHZ9+aY0bCi8xTlyqwF2u9dbWSC0PPXCb8stiTwkPju5IZKkt3uxfZcUxOprzY6i/0bA
 8HmQtxnnsOe9AFF+gQvzvDap3LGKu+ebMGIn3ZuneypesVSG/jwyF7ip2c+rZOKzBmtQ9R8Fj
 wyQDBX94cTmMAojeRNhnTv3O+aZHJxiscaoxnEerv+/Q3+0sP3+fG6E8OZcYWlNYecsUGmFb4
 flMJF3K4JbR0FGboE8oKah2mnEUiEBlnITS8aT98vVHSRw37bDzL5b/dDdIuHpOmglkazHPHW
 dInaiKwbFaKY0Lnxcybvl88zoWUjksSBicKZof5wn3joLbrwloFe/ZP3EBaTHKitQAf7mm5dB
 9H8g56z3rOU8D0jfMwaXCLSQnsgSxFP9VIWLKvnV5DRBevvd1g4RLOQ+42PMH0x0KA78C1GJA
 58oz1VkBFp2otjJE3irR6kDLrXssp7grfL9Ed6MAC+9qgO9/S8snLkCLnsDfDYB8oZnktNfi1
 j0hEJqt4gzj8wNcOxVc9dTQaw78bsEFmjrK7FsTTZt1Xrmcr1LfVG+CyM6KvUx6X+hVfqMoxR
 xCfGu8WIOv22XxXptyhsk2eyt2PH5usNz8d+A8AFc/xdvF6zi1sz1d35l68NeAN5ptA/0UL3l
 99yoSWLov8hgFPd3am7VQ7NddJ9ShUy5gcNwlaorQ4mFYdin1xirltca+niOc5ve/Qyqy4QGz
 0UH2pg1fhBk00K2eNoO1o08iPPg0uRSH+8lj7UsTQmBpLVMhSUOC625nmXFd1pKBAGpqN+2oa
 y5ZmSGh2y1+/aOVPg2bFqk3K09PZ3ssnj64UlYerxignMzMwvPB3+7BuKYBNfZu4m4x229Nxy
 lwqeHNmuj9hchUUSVz2W8TzJxZCWdPU6Yu18088+Sw/TZM3sotlY5Ljxk9ndB4Xk4F/VXwiuC
 sV7nm3gpZWmj5AoCXa/GEiVW4357Ih6rFDO4Xg0x0U1BLIhiOIBkfWWEhQN+NU72g6iEL5Xkn
 d/61ZHGCLXu8swzSDDCGEDmUs+jx5brI1fl
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

made some progress understanding why vmport from L2 breaks since QEMU gets/sets
the nested state around it: We do not preserve VM_EXIT_INSTRUCTION_LEN, and that
breaks skip_emulated_instruction when completing the PIO access on next run. The
field is suddenly 0, and so we loop infinitely over the IO instruction. Unless
some other magic prevents migration while an IO instruction is in flight, vmport
may not be the only victim here.

Now the question is how to preserve that information: Can we restore the value
into vmcs02 on set_nested_state, despite this field being read-only? Or do we
need to cache its content and use that instead in skip_emulated_instruction?

Looking at this pattern, I wonder if there is more. What other fields are used
across PIO or MMIO when the handling is done by userland?

Jan
