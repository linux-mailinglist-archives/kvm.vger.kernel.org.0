Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A23B2E0E4C
	for <lists+kvm@lfdr.de>; Tue, 22 Dec 2020 19:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgLVSn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 13:43:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53434 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725913AbgLVSn3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Dec 2020 13:43:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608662522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vHpMx2Tmn2p+8fwxuNVV9TdK19UK3/OI7GEAeBsSXuk=;
        b=MLQ3m8CB1MAWPM7mSvQ/g7fNO+HlWR7sSltu85ggtToaTIUp5Jd0q9XQrJStKf0yMkvHdP
        vnLLJBaToxk+Iyx/eFp1jfCCTPa3O/f7tIFNW0yPV+en6LvV6tkjd6iN2oiA3PZQ6Zk0ma
        u0Cq+TlfImFaAXqabaMOqICy6aHL0bA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-5UqmchdLNVOuIZXkIQoR4Q-1; Tue, 22 Dec 2020 13:41:58 -0500
X-MC-Unique: 5UqmchdLNVOuIZXkIQoR4Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9B771005513;
        Tue, 22 Dec 2020 18:41:54 +0000 (UTC)
Received: from wainer-laptop.localdomain (ovpn-114-123.rdu2.redhat.com [10.10.114.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52E715D9CC;
        Tue, 22 Dec 2020 18:41:48 +0000 (UTC)
Subject: Re: [PATCH 0/9] Alpine Linux build fix and CI pipeline
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-devel@nongnu.org
Cc:     kwolf@redhat.com, fam@euphon.net, thuth@redhat.com,
        kvm@vger.kernel.org, viktor.prutyanov@phystech.edu,
        lvivier@redhat.com, alex.bennee@linaro.org, alistair@alistair23.me,
        groug@kaod.org, mreitz@redhat.com, qemu-ppc@nongnu.org,
        pbonzini@redhat.com, qemu-block@nongnu.org, philmd@redhat.com,
        david@gibson.dropbear.id.au
References: <160851280526.21294.6201442635975331015@600e7e483b3a>
 <1389d6d1-33fe-46cc-b03c-f2a40e03853b@www.fastmail.com>
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
Message-ID: <431a4029-afdf-9a31-ba9a-ebfeef24faaa@redhat.com>
Date:   Tue, 22 Dec 2020 15:41:46 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1389d6d1-33fe-46cc-b03c-f2a40e03853b@www.fastmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 12/21/20 5:25 AM, Jiaxun Yang wrote:
>
> On Mon, Dec 21, 2020, at 9:06 AM, no-reply@patchew.org wrote:
>> Patchew URL:
>> https://patchew.org/QEMU/20201221005318.11866-1-jiaxun.yang@flygoat.com/
>>
>>
>>
>> Hi,
>>
>> This series seems to have some coding style problems. See output below for
>> more information:
>>
>> Type: series
>> Message-id: 20201221005318.11866-1-jiaxun.yang@flygoat.com
>> Subject: [PATCH 0/9] Alpine Linux build fix and CI pipeline
>>
>> === TEST SCRIPT BEGIN ===
>> #!/bin/bash
>> git rev-parse base > /dev/null || exit 0
>> git config --local diff.renamelimit 0
>> git config --local diff.renames True
>> git config --local diff.algorithm histogram
>> ./scripts/checkpatch.pl --mailback base..
>> === TEST SCRIPT END ===
>>
>> Updating 3c8cf5a9c21ff8782164d1def7f44bd888713384
>>  From https://github.com/patchew-project/qemu
>>   * [new tag]
>> patchew/20201221005318.11866-1-jiaxun.yang@flygoat.com ->
>> patchew/20201221005318.11866-1-jiaxun.yang@flygoat.com
>> Switched to a new branch 'test'
>> 10095a9 gitlab-ci: Add alpine to pipeline
>> a177af3 tests: Rename PAGE_SIZE definitions
>> 5fcb0ed accel/kvm: avoid using predefined PAGE_SIZE
>> e7febdf hw/block/nand: Rename PAGE_SIZE to NAND_PAGE_SIZE
>> ba307d5 elf2dmp: Rename PAGE_SIZE to ELF2DMP_PAGE_SIZE
>> 0ccf92b libvhost-user: Include poll.h instead of sys/poll.h
>> 41a10db configure/meson: Only check sys/signal.h on non-Linux
>> 0bcd2f2 configure: Add sys/timex.h to probe clk_adjtime
>> a16c7ff tests/docker: Add dockerfile for Alpine Linux
>>
>> === OUTPUT BEGIN ===
>> 1/9 Checking commit a16c7ff7d859 (tests/docker: Add dockerfile for Alpine Linux)
>> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
>> #20:
>> new file mode 100644
>>
>> total: 0 errors, 1 warnings, 56 lines checked
>>
>> Patch 1/9 has style problems, please review.  If any of these errors
>> are false positives report them to the maintainer, see
>> CHECKPATCH in MAINTAINERS.
>> 2/9 Checking commit 0bcd2f2eae84 (configure: Add sys/timex.h to probe
>> clk_adjtime)
>> 3/9 Checking commit 41a10dbdc8da (configure/meson: Only check
>> sys/signal.h on non-Linux)
>> 4/9 Checking commit 0ccf92b8ec37 (libvhost-user: Include poll.h instead
>> of sys/poll.h)
>> 5/9 Checking commit ba307d5a51aa (elf2dmp: Rename PAGE_SIZE to
>> ELF2DMP_PAGE_SIZE)
>> WARNING: line over 80 characters
>> #69: FILE: contrib/elf2dmp/main.c:284:
>> +        h.PhysicalMemoryBlock.NumberOfPages += ps->block[i].size /
>> ELF2DMP_PAGE_SIZE;
>>
>> WARNING: line over 80 characters
>> #79: FILE: contrib/elf2dmp/main.c:291:
>> +    h.RequiredDumpSpace += h.PhysicalMemoryBlock.NumberOfPages <<
>> ELF2DMP_PAGE_BITS;
>>
>> total: 0 errors, 2 warnings, 70 lines checked
>>
>> Patch 5/9 has style problems, please review.  If any of these errors
>> are false positives report them to the maintainer, see
>> CHECKPATCH in MAINTAINERS.
>> 6/9 Checking commit e7febdf0b056 (hw/block/nand: Rename PAGE_SIZE to
>> NAND_PAGE_SIZE)
>> ERROR: code indent should never use tabs
>> #26: FILE: hw/block/nand.c:117:
>> +# define PAGE_START(page)^I(PAGE(page) * (NAND_PAGE_SIZE + OOB_SIZE))$
>>
>> ERROR: code indent should never use tabs
>> #46: FILE: hw/block/nand.c:134:
>> +# define NAND_PAGE_SIZE^I^I2048$
>>
>> WARNING: line over 80 characters
>> #65: FILE: hw/block/nand.c:684:
>> +        mem_and(iobuf + (soff | off), s->io, MIN(s->iolen,
>> NAND_PAGE_SIZE - off));
>>
>> WARNING: line over 80 characters
>> #70: FILE: hw/block/nand.c:687:
>> +            mem_and(s->storage + (page << OOB_SHIFT), s->io +
>> NAND_PAGE_SIZE - off,
>>
>> total: 2 errors, 2 warnings, 120 lines checked
>>
>> Patch 6/9 has style problems, please review.  If any of these errors
>> are false positives report them to the maintainer, see
>> CHECKPATCH in MAINTAINERS.
>>
>> 7/9 Checking commit 5fcb0ed1331a (accel/kvm: avoid using predefined PAGE_SIZE)
>> 8/9 Checking commit a177af33938d (tests: Rename PAGE_SIZE definitions)
>> 9/9 Checking commit 10095a92643d (gitlab-ci: Add alpine to pipeline)
>> === OUTPUT END ===
>>
>> Test command exited with code: 1
> All pre-existing errors.

Apparently some style errors were introduced by the patches 05 and 06.

- Wainer

>
>>
>> The full log is available at
>> http://patchew.org/logs/20201221005318.11866-1-jiaxun.yang@flygoat.com/testing.checkpatch/?type=message.
>> ---
>> Email generated automatically by Patchew [https://patchew.org/].
>> Please send your feedback to patchew-devel@redhat.com

