Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40FC36F4FD
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2019 21:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfGUTcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Jul 2019 15:32:06 -0400
Received: from mout.web.de ([212.227.15.14]:57817 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726946AbfGUTcG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Jul 2019 15:32:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1563737511;
        bh=uXX77+l3TJgQUU/wkp638cs8iFvTt2OT8EDRt/91Erc=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=NaqWnwd/5fbtRewSCy2lYvtXl5OoFSgRoZ5twyId5cVUbFbEXfqYnuIXcLvpAuIRo
         bGn+cFlENI7PnOTYzZv+NF+jyEvw72e94vCuHo9Sy01AGPDGNCQQjrcExLLzVP73vZ
         tU9gXUSoAh8aQLQX6Y949nIGG2NDXUgJJTb+YA7E=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.55.156]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LmxtE-1iL0oc3JYi-00h9wb; Sun, 21
 Jul 2019 21:31:50 +0200
Subject: Re: nvmx: get/set_nested_state ignores VM_EXIT_INSTRUCTION_LEN
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>, kvm <kvm@vger.kernel.org>
Cc:     Jim Mattson <jmattson@google.com>,
        KarimAllah Ahmed <karahmed@amazon.de>
References: <3299adf3-3979-7718-702f-bab2d9324c69@web.de>
 <5bfb611e-f136-d9e4-7888-123d21e738c2@redhat.com>
From:   Jan Kiszka <jan.kiszka@web.de>
Message-ID: <c6da9913-1ede-2a54-53c1-fcce0217e987@web.de>
Date:   Sun, 21 Jul 2019 21:31:49 +0200
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
In-Reply-To: <5bfb611e-f136-d9e4-7888-123d21e738c2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:mJDvRptNBlL5L5SPn1xbDwkBOgSqpeCiZnLyAP15gCmbFtbCiJ4
 lspb8zySPDPzm3XO8Z1jQoiGZr7RrkPxk48DNaTZA780orYQOvFtxMIYmdNb8IWtjBSuQ3Q
 i6k5sI6tU0l9JKTdj4bHtAJYb8WwwiEQYi0g0bfQuCrlZxi+/Qb9QyJLVStcBGNgW3OLMJW
 CdsDSsgWEuL8bGlP54L1Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:n8GZvdeYcTY=:XlTGCohfqi6kTl/VQO3yz4
 bgdRpMJH7ShAoozMr9YQGR9NBRxscfr5MkrUiUVGbz9uvLJFdv5B5Dz4K8AbLs5UgzFEgdcln
 GQuve9BbMwdyB1ivv7aGdCalT52C+DvB1ZQqiAJ9QOANe124FJghd+jSrHzVp1E/Co71VhPcT
 UYAl/lEZqO6bvl3n4priIvbNxVLl0tSaetoXtMdNE7r3FVYY3O6C9xgU+FluZ0e1UJxLLuM3I
 5fpbAbDHADOcHUa/KVY8vScBRkaVwIRqq/WySNWuHXCUbDvsju7FNiuIn4qobiHev54se+H/m
 /I2mQeRlx9n1f8ffORboPnMO9v01RXT1+yU5YqERJPXW2Jci4FfF7QPzzpZIhWxmygNgAsFpT
 gEW1YXuwjvOZjHcENlVEFEoQN/3abMKH2bMBVlaxT3k3xoD0CdONiiiXx0qxZq+vby4AHq2XH
 cwzrZDsKTaOZZ5IqKkcZmYwlxEuytRWcNuFORvr9gNlt//m9HtjuhhsJsnoySlsqIhIelgKoe
 PiD3lQVGN42xAQMgS7siWCJQKcyy721IBBNzCfq5atCuih0+fk5nrXLWZ0PxcLbXuY1ARz9FG
 eKfX0YdumT3YvnACocntSYyfJv8jdnDB1Ccb1hLVZWs79iAUP5HD9OqAM7QuJTgHCF5goHWux
 bu+zvbt7eztOLogqScgga2a9afIwtks7DfvRilD6Y516EHB+BxTwBcC93MI84rVxqPzNQHnOx
 PgWG7VpF5pnYxMbuo3oy71gp7M83thvF2crAEEIdZVxZplEoGShGoeH1J4CrWIbccQDgV8Y+N
 cUYAWjMQxJOIf8+OAakoEL42ghGNRw7YM6X8OA01z/74JQEHqm9T+2+hYCkuOH62jLyQgEqP6
 e+Sh9HJZ76vuupOYSrJ7wzPqED7Qjwo+XgNdtm2s5xoynEFyi+ZlzLbepTqYR6bkTtq/CT8pn
 yfeOfVxNZUoehTj69ZUhv3nLUDqz1bVe+EnRbSVD13fAqQ1a6yqr2G+wNHS/fkBYLApA6G6pT
 mfejJmpeZOta6tr3NrHK0Sa2cR75fHeuyN2ICPhibQKgxWvaPsC1gLRVcVqlNLINIQ2FW+3w6
 COeurFlbnihy2H1X+CEeZDbIl+SfpvhUsTXEF1K/6dnaEQ+aNpkC14RHht03pugJmG9Xqk2rw
 0fGW2bb2sb1Gvdneo3cEYwdrPFSHGj0jmF5SEi06lUhfqIUpc2QbWVVZ9oR3er/ZagqExD8Oq
 EhF3nqeXrHNGtk7vG
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.07.19 21:14, Paolo Bonzini wrote:
> On 21/07/19 19:40, Jan Kiszka wrote:
>> Hi all,
>>
>> made some progress understanding why vmport from L2 breaks since QEMU g=
ets/sets
>> the nested state around it: We do not preserve VM_EXIT_INSTRUCTION_LEN,=
 and that
>> breaks skip_emulated_instruction when completing the PIO access on next=
 run. The
>> field is suddenly 0, and so we loop infinitely over the IO instruction.=
 Unless
>> some other magic prevents migration while an IO instruction is in fligh=
t, vmport
>> may not be the only victim here.
>>
>> Now the question is how to preserve that information: Can we restore th=
e value
>> into vmcs02 on set_nested_state, despite this field being read-only? Or=
 do we
>> need to cache its content and use that instead in skip_emulated_instruc=
tion?
>
> Hmm I think technically this is invalid, since you're not supposed to
> modify state at all while MMIO is pending.  Of course that's kinda moot
> if it's the only way to emulate vmport, but perhaps we can (or even
> should!) fix it in QEMU.  Is KVM_SET_NESTED_STATE needed for level <
> KVM_PUT_RESET_STATE?  Even if it is, we should first complete I/O and
> then do kvm_arch_put_registers.

Are we sure that vmport is the only case? What prevents a migration from
starting in the middle of an IO exit?

And I suspect we need to enhance the API specification then.

Jan
