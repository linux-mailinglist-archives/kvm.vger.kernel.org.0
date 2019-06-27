Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73021587CD
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 18:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfF0Q6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 12:58:11 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:47996 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfF0Q6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 12:58:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1561654689; x=1593190689;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=bSTBBNAfMQJYKBrNLp5ZpVMPDUXmFDWBqbuxlfFG2gs=;
  b=Hcr8R3+KsshbrbQ7j6oFF2hP/NbVINCSk1UkppWL1UDjNn2djBIcNgu2
   9MaHTxuYzlJneiH/CuO7fbk7pH19NLo8M5yF/elojtm9+XIUEvExNh00w
   nHZt2TgFx2pvsM55k/KiJ/ZAl9i4ihF1Y0a/zsGHlT4If05q+odZwVzia
   A=;
X-IronPort-AV: E=Sophos;i="5.62,424,1554768000"; 
   d="scan'208";a="772347404"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 27 Jun 2019 16:58:08 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id C5C98A2075;
        Thu, 27 Jun 2019 16:58:03 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 27 Jun 2019 16:58:03 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.128) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 27 Jun 2019 16:57:58 +0000
Subject: Re: [PATCH v3 4/5] Added build and install scripts
To:     Sam Caccavale <samcacc@amazon.de>
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
From:   Alexander Graf <graf@amazon.com>
Message-ID: <e0b29f4d-7471-c5d8-c9d4-2a352831a4bd@amazon.com>
Date:   Thu, 27 Jun 2019 18:57:57 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190624142414.22096-5-samcacc@amazon.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.128]
X-ClientProxiedBy: EX13D01UWA003.ant.amazon.com (10.43.160.107) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24.06.19 16:24, Sam Caccavale wrote:
> install_afl.sh installs AFL locally and emits AFLPATH,
> build.sh, and run.sh build and run respectively
> 
> ---
> 
> v1 -> v2:
>   - Introduced this patch
> 
> v2 -> v3:
>   - Moved non-essential development scripts to a later patch
> 
> Signed-off-by: Sam Caccavale <samcacc@amazon.de>
> ---
>   tools/fuzz/x86ie/scripts/afl-many       | 31 +++++++++++++++++++++++
>   tools/fuzz/x86ie/scripts/build.sh       | 33 +++++++++++++++++++++++++
>   tools/fuzz/x86ie/scripts/install_afl.sh | 17 +++++++++++++
>   tools/fuzz/x86ie/scripts/run.sh         | 10 ++++++++
>   4 files changed, 91 insertions(+)
>   create mode 100755 tools/fuzz/x86ie/scripts/afl-many
>   create mode 100755 tools/fuzz/x86ie/scripts/build.sh
>   create mode 100755 tools/fuzz/x86ie/scripts/install_afl.sh
>   create mode 100755 tools/fuzz/x86ie/scripts/run.sh
> 
> diff --git a/tools/fuzz/x86ie/scripts/afl-many b/tools/fuzz/x86ie/scripts/afl-many
> new file mode 100755
> index 000000000000..e55ff115a777
> --- /dev/null
> +++ b/tools/fuzz/x86ie/scripts/afl-many
> @@ -0,0 +1,31 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +# This is for running AFL over NPROC or `nproc` cores with normal AFL options ex:
> +# ulimit -Sv $[21999999999 << 10]; ./tools/fuzz/x86ie/scripts/afl-many -m 22000000000 -i $FUZZDIR/in -o $FUZZDIR/out tools/fuzz/x86ie/afl-harness @@
> +
> +export AFL_NO_AFFINITY=1
> +
> +while [ -z "$sync_dir" ]; do
> +  while getopts ":o:" opt; do
> +    case "${opt}" in
> +      o)
> +        sync_dir="${OPTARG}"
> +        ;;
> +      *)
> +        ;;
> +    esac
> +  done
> +  ((OPTIND++))
> +  [ $OPTIND -gt $# ] && break
> +done
> +
> +# AFL/linux do some weird stuff with core affinity and will often run
> +# N processes over < N virtual cores.  In order to avoid that, we taskset
> +# each process to its own core.
> +for i in $(seq 1 $(( ${NPROC:-$(nproc)} - 1)) ); do
> +    taskset -c "$i" ./afl-fuzz -S "slave$i" $@ >/dev/null 2>&1 &
> +done
> +taskset -c 0 ./afl-fuzz -M master $@ >/dev/null 2>&1 &
> +
> +watch -n1 "echo \"Executing '$AFLPATH/afl-fuzz $@' on ${NPROC:-$(nproc)} cores.\" && $AFLPATH/afl-whatsup -s ${sync_dir}"
> +pkill afl-fuzz
> diff --git a/tools/fuzz/x86ie/scripts/build.sh b/tools/fuzz/x86ie/scripts/build.sh
> new file mode 100755
> index 000000000000..032762bf56ef
> --- /dev/null
> +++ b/tools/fuzz/x86ie/scripts/build.sh
> @@ -0,0 +1,33 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +# Run from root of linux via `./tools/fuzz/x86ie/scripts/build.sh`
> +
> +kernel_objects="arch/x86/kvm/emulate.o arch/x86/lib/retpoline.o lib/find_bit.o"
> +
> +disable() { sed -i -r "/\b$1\b/c\# $1" .config; }
> +enable() { sed -i -r "/\b$1\b/c\\$1=y" .config; }
> +
> +make ${CC:+ "CC=$CC"} ${DEBUG:+ "DEBUG=1"} defconfig
> +
> +enable "CONFIG_DEBUG_INFO"
> +enable "CONFIG_STACKPROTECTOR"
> +
> +yes ' ' | make ${CC:+ "CC=$CC"} ${DEBUG:+ "DEBUG=1"} $kernel_objects
> +
> +omit_arg () { args=$(echo "$args" | sed "s/ $1//g"); }
> +add_arg () { args+=" $1"; }
> +
> +rebuild () {
> +  args="$(head -1 $(dirname $1)/.$(basename $1).cmd | sed -e 's/.*:= //g')"
> +  omit_arg "-mcmodel=kernel"
> +  omit_arg "-mpreferred-stack-boundary=3"
> +  add_arg "-fsanitize=address"
> +  echo -e "Rebuilding $1 with \n$args"
> +  eval "$args"
> +}
> +
> +for object in $kernel_objects; do
> +  rebuild $object
> +done
> +
> +make ${CC:+ "CC=$CC"} ${DEBUG:+ "DEBUG=1"} tools/fuzz
> diff --git a/tools/fuzz/x86ie/scripts/install_afl.sh b/tools/fuzz/x86ie/scripts/install_afl.sh
> new file mode 100755
> index 000000000000..3bdbdf2a040b
> --- /dev/null
> +++ b/tools/fuzz/x86ie/scripts/install_afl.sh
> @@ -0,0 +1,17 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +# Can be run where ever, but usually run from linux root:
> +# `source ./tools/fuzz/x86ie/scripts/install_afl.sh`
> +# (must be sourced to get the AFLPATH envvar, otherwise set manually)
> +
> +wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
> +mkdir -p afl
> +tar xzf afl-latest.tgz -C afl --strip-components 1
> +
> +pushd afl
> +set AFL_USE_ASAN
> +make clean all
> +export AFLPATH="$(pwd)"
> +popd
> +
> +sudo bash -c "echo core >/proc/sys/kernel/core_pattern"

What is this? :)

Surely if it's important to generate core dumps, it's not only important 
during installation, no?

Alex

> diff --git a/tools/fuzz/x86ie/scripts/run.sh b/tools/fuzz/x86ie/scripts/run.sh
> new file mode 100755
> index 000000000000..0571cd524c01
> --- /dev/null
> +++ b/tools/fuzz/x86ie/scripts/run.sh
> @@ -0,0 +1,10 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +
> +FUZZDIR="${FUZZDIR:-$(pwd)/fuzz}"
> +
> +mkdir -p $FUZZDIR/in
> +cp tools/fuzz/x86ie/rand_sample.bin $FUZZDIR/in
> +mkdir -p $FUZZDIR/out
> +
> +screen bash -c "ulimit -Sv $[21999999999 << 10]; ./tools/fuzz/x86ie/scripts/afl-many -m 22000000000 -i $FUZZDIR/in -o $FUZZDIR/out tools/fuzz/x86ie/afl-harness @@"
> 
