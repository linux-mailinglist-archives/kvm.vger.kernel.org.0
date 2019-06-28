Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2434B59571
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 10:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfF1IAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 04:00:02 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:16188 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfF1IAC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 04:00:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1561708800; x=1593244800;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=4qGS+AQAGSNeAG/Cjn3Fouyx+bazTFBBQ+/Oq4UuvLw=;
  b=fe6ArrEhR34tnN6IZSBGi3QVu+bOb+qYNZUEmkzzzhhUBuPHtbE1nuf1
   VSp5KEkwvNYRwf79ih+knd29bPanqdAggUKUWUVtltw1ZV6Gm5Fh5rGhQ
   niG9wwyMklRN768biJ7nlxJoJxltsSr0ruaAtIbtZJ7fz+IqBxxfHBrYk
   o=;
X-IronPort-AV: E=Sophos;i="5.62,426,1554768000"; 
   d="scan'208";a="408511790"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 28 Jun 2019 07:59:57 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 5DEEAA0581;
        Fri, 28 Jun 2019 07:59:56 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 07:59:56 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 07:59:55 +0000
Received: from u6cf1b7119fa15b.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 28 Jun 2019 07:59:50 +0000
Subject: Re: [PATCH v3 4/5] Added build and install scripts
To:     Alexander Graf <graf@amazon.com>, Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <karahmed@amazon.de>, <andrew.cooper3@citrix.com>,
        <JBeulich@suse.com>, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <paullangton4@gmail.com>,
        <anirudhkaushik@google.com>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20190624142414.22096-1-samcacc@amazon.de>
 <20190624142414.22096-5-samcacc@amazon.de>
 <e0b29f4d-7471-c5d8-c9d4-2a352831a4bd@amazon.com>
From:   <samcacc@amazon.com>
Message-ID: <6fa5e9de-7b66-76ba-0b98-e11f890e076a@amazon.com>
Date:   Fri, 28 Jun 2019 09:59:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <e0b29f4d-7471-c5d8-c9d4-2a352831a4bd@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/27/19 6:57 PM, Alexander Graf wrote:
> 
> 
> On 24.06.19 16:24, Sam Caccavale wrote:
>> install_afl.sh installs AFL locally and emits AFLPATH,
>> build.sh, and run.sh build and run respectively
>>
>> ---
>>
>> v1 -> v2:
>>   - Introduced this patch
>>
>> v2 -> v3:
>>   - Moved non-essential development scripts to a later patch
>>
>> Signed-off-by: Sam Caccavale <samcacc@amazon.de>
>> ---
>>   tools/fuzz/x86ie/scripts/afl-many       | 31 +++++++++++++++++++++++
>>   tools/fuzz/x86ie/scripts/build.sh       | 33 +++++++++++++++++++++++++
>>   tools/fuzz/x86ie/scripts/install_afl.sh | 17 +++++++++++++
>>   tools/fuzz/x86ie/scripts/run.sh         | 10 ++++++++
>>   4 files changed, 91 insertions(+)
>>   create mode 100755 tools/fuzz/x86ie/scripts/afl-many
>>   create mode 100755 tools/fuzz/x86ie/scripts/build.sh
>>   create mode 100755 tools/fuzz/x86ie/scripts/install_afl.sh
>>   create mode 100755 tools/fuzz/x86ie/scripts/run.sh
>>
>> diff --git a/tools/fuzz/x86ie/scripts/afl-many
>> b/tools/fuzz/x86ie/scripts/afl-many
>> new file mode 100755
>> index 000000000000..e55ff115a777
>> --- /dev/null
>> +++ b/tools/fuzz/x86ie/scripts/afl-many
>> @@ -0,0 +1,31 @@
>> +#!/bin/bash
>> +# SPDX-License-Identifier: GPL-2.0+
>> +# This is for running AFL over NPROC or `nproc` cores with normal AFL
>> options ex:
>> +# ulimit -Sv $[21999999999 << 10];
>> ./tools/fuzz/x86ie/scripts/afl-many -m 22000000000 -i $FUZZDIR/in -o
>> $FUZZDIR/out tools/fuzz/x86ie/afl-harness @@
>> +
>> +export AFL_NO_AFFINITY=1
>> +
>> +while [ -z "$sync_dir" ]; do
>> +  while getopts ":o:" opt; do
>> +    case "${opt}" in
>> +      o)
>> +        sync_dir="${OPTARG}"
>> +        ;;
>> +      *)
>> +        ;;
>> +    esac
>> +  done
>> +  ((OPTIND++))
>> +  [ $OPTIND -gt $# ] && break
>> +done
>> +
>> +# AFL/linux do some weird stuff with core affinity and will often run
>> +# N processes over < N virtual cores.  In order to avoid that, we
>> taskset
>> +# each process to its own core.
>> +for i in $(seq 1 $(( ${NPROC:-$(nproc)} - 1)) ); do
>> +    taskset -c "$i" ./afl-fuzz -S "slave$i" $@ >/dev/null 2>&1 &
>> +done
>> +taskset -c 0 ./afl-fuzz -M master $@ >/dev/null 2>&1 &
>> +
>> +watch -n1 "echo \"Executing '$AFLPATH/afl-fuzz $@' on
>> ${NPROC:-$(nproc)} cores.\" && $AFLPATH/afl-whatsup -s ${sync_dir}"
>> +pkill afl-fuzz
>> diff --git a/tools/fuzz/x86ie/scripts/build.sh
>> b/tools/fuzz/x86ie/scripts/build.sh
>> new file mode 100755
>> index 000000000000..032762bf56ef
>> --- /dev/null
>> +++ b/tools/fuzz/x86ie/scripts/build.sh
>> @@ -0,0 +1,33 @@
>> +#!/bin/bash
>> +# SPDX-License-Identifier: GPL-2.0+
>> +# Run from root of linux via `./tools/fuzz/x86ie/scripts/build.sh`
>> +
>> +kernel_objects="arch/x86/kvm/emulate.o arch/x86/lib/retpoline.o
>> lib/find_bit.o"
>> +
>> +disable() { sed -i -r "/\b$1\b/c\# $1" .config; }
>> +enable() { sed -i -r "/\b$1\b/c\\$1=y" .config; }
>> +
>> +make ${CC:+ "CC=$CC"} ${DEBUG:+ "DEBUG=1"} defconfig
>> +
>> +enable "CONFIG_DEBUG_INFO"
>> +enable "CONFIG_STACKPROTECTOR"
>> +
>> +yes ' ' | make ${CC:+ "CC=$CC"} ${DEBUG:+ "DEBUG=1"} $kernel_objects
>> +
>> +omit_arg () { args=$(echo "$args" | sed "s/ $1//g"); }
>> +add_arg () { args+=" $1"; }
>> +
>> +rebuild () {
>> +  args="$(head -1 $(dirname $1)/.$(basename $1).cmd | sed -e 's/.*:=
>> //g')"
>> +  omit_arg "-mcmodel=kernel"
>> +  omit_arg "-mpreferred-stack-boundary=3"
>> +  add_arg "-fsanitize=address"
>> +  echo -e "Rebuilding $1 with \n$args"
>> +  eval "$args"
>> +}
>> +
>> +for object in $kernel_objects; do
>> +  rebuild $object
>> +done
>> +
>> +make ${CC:+ "CC=$CC"} ${DEBUG:+ "DEBUG=1"} tools/fuzz
>> diff --git a/tools/fuzz/x86ie/scripts/install_afl.sh
>> b/tools/fuzz/x86ie/scripts/install_afl.sh
>> new file mode 100755
>> index 000000000000..3bdbdf2a040b
>> --- /dev/null
>> +++ b/tools/fuzz/x86ie/scripts/install_afl.sh
>> @@ -0,0 +1,17 @@
>> +#!/bin/bash
>> +# SPDX-License-Identifier: GPL-2.0+
>> +# Can be run where ever, but usually run from linux root:
>> +# `source ./tools/fuzz/x86ie/scripts/install_afl.sh`
>> +# (must be sourced to get the AFLPATH envvar, otherwise set manually)
>> +
>> +wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
>> +mkdir -p afl
>> +tar xzf afl-latest.tgz -C afl --strip-components 1
>> +
>> +pushd afl
>> +set AFL_USE_ASAN
>> +make clean all
>> +export AFLPATH="$(pwd)"
>> +popd
>> +
>> +sudo bash -c "echo core >/proc/sys/kernel/core_pattern"
> 
> What is this? :)
> 
> Surely if it's important to generate core dumps, it's not only important
> during installation, no?

Yep... missed this.  I'll move it to run.sh right before alf-many is
invoked.  It would be nice to not have to sudo but it seems the only
alternative is an envvar AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES which
just ignores AFL's warning if your system isn't going to produce core
dumps (which will cause AFL to miss some crashes, as the name suggests).

Thanks for all the feedback thusfar,
Sam

> 
> Alex
> 
>> diff --git a/tools/fuzz/x86ie/scripts/run.sh
>> b/tools/fuzz/x86ie/scripts/run.sh
>> new file mode 100755
>> index 000000000000..0571cd524c01
>> --- /dev/null
>> +++ b/tools/fuzz/x86ie/scripts/run.sh
>> @@ -0,0 +1,10 @@
>> +#!/bin/bash
>> +# SPDX-License-Identifier: GPL-2.0+
>> +
>> +FUZZDIR="${FUZZDIR:-$(pwd)/fuzz}"
>> +
>> +mkdir -p $FUZZDIR/in
>> +cp tools/fuzz/x86ie/rand_sample.bin $FUZZDIR/in
>> +mkdir -p $FUZZDIR/out
>> +
>> +screen bash -c "ulimit -Sv $[21999999999 << 10];
>> ./tools/fuzz/x86ie/scripts/afl-many -m 22000000000 -i $FUZZDIR/in -o
>> $FUZZDIR/out tools/fuzz/x86ie/afl-harness @@"
>>

