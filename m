Return-Path: <kvm+bounces-50845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4731FAEA2B2
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 17:34:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 82F06188B260
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 15:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FEA12EBDE2;
	Thu, 26 Jun 2025 15:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U45XfFqA"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99EA35975
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 15:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750951782; cv=none; b=bYYitOfDbE0H+5uNgitDePnHJGsNs2OqMCDqpLpGykFMUrBh5AF1ouiJ1mom6Yk/CVRXBMiXQHse7mwe6vSsL8wl4ezAcM+vK1h3MBmu/gZxTHHoV7JqRCZM99riYEpg7RjqU7kWjbzzkdkTUhiP2gelXxoKze7yQilnArU/ht0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750951782; c=relaxed/simple;
	bh=PlhIbg0CrqBxUdRfXHwXe7RPphROJFXda3eZtMsfFrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hF+5wJo03uIEceEim19Jtlms6ONCsw4wcojcExOwNf/w6lIpefe7Y0sxrFRultVSEX3xsL3+xdmiT5nt6vwEIQTjgVQtVXgTQ21y8tziZKMshcddyrYyekZ9EvqBgWX0vDU1K8UkUBYkOUAdKDXL3oUJaKSGlfXlcBhM6QohmaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U45XfFqA; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 26 Jun 2025 17:29:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750951769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B7njsQqS9+YDhVOAJu3gcu6bWM9s+UemRcmSG7r3Qvs=;
	b=U45XfFqA2ERqttsJj+PAHPpQC2ZDqBxFOMZkRVL0AKADe70nTLxOPuIU65WzUbbUkfsd+b
	5F4Vl+NzEJJXuyUPzkvbfiUTJcyprTFO9NS8GCkwKwzbJoV8XZN2iwQViQVZoVEXuKzyna
	Yg50+iFSUL3/OH0CegRsxadieDifpF4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com, shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 04/13] scripts: Use an associative
 array for qemu argument names
Message-ID: <20250626-5cba2905b81b7a5b3a016bfa@orel>
References: <20250625154813.27254-1-alexandru.elisei@arm.com>
 <20250625154813.27254-5-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625154813.27254-5-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 25, 2025 at 04:48:04PM +0100, Alexandru Elisei wrote:
> Move away from hardcoded qemu arguments and use instead an associative
> array to get the needed arguments. This paves the way for adding kvmtool
> support to the scripts, which has a different syntax for the same VM
> configuration parameters.
> 
> Suggested-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> 
> Changes v3->v4:
> 
> * Renamed vmm_opts to vmm_optname.
> * Dropped entries for 'kernel' and 'initrd' in vmm_optname because they weren't
> used in this patch.
> * Use vmm_optname_nr_cpus() and vmm_optname_args() instead of directly indexing
> into vmm_optname.
> * Dropped the check for empty $test_args in scripts/runtime.bash::run() by
> having $test_args already contain --append if not empty in
> scripts/common.bash::for_each_unittest().
> 
>  scripts/common.bash  | 11 ++++++++---
>  scripts/runtime.bash |  7 +------
>  scripts/vmm.bash     | 15 +++++++++++++++
>  3 files changed, 24 insertions(+), 9 deletions(-)
> 
> diff --git a/scripts/common.bash b/scripts/common.bash
> index 9deb87d4050d..ae127bd4e208 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -1,4 +1,5 @@
>  source config.mak
> +source scripts/vmm.bash
>  
>  function for_each_unittest()
>  {
> @@ -26,8 +27,12 @@ function for_each_unittest()
>  				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$test_args" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
>  			fi
>  			testname=$rematch
> -			smp=1
> +			smp="$(vmm_optname_nr_cpus) 1"
>  			kernel=""
> +			# Intentionally don't use -append if test_args is empty
> +			# because qemu interprets the first word after
> +			# -append as a kernel parameter instead of a command
> +			# line option.
>  			test_args=""
>  			opts=""
>  			groups=""
> @@ -39,9 +44,9 @@ function for_each_unittest()
>  		elif [[ $line =~ ^file\ *=\ *(.*)$ ]]; then
>  			kernel=$TEST_DIR/${BASH_REMATCH[1]}
>  		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
> -			smp=${BASH_REMATCH[1]}
> +			smp="$(vmm_optname_nr_cpus) ${BASH_REMATCH[1]}"
>  		elif [[ $line =~ ^test_args\ *=\ *(.*)$ ]]; then
> -			test_args=${BASH_REMATCH[1]}
> +			test_args="$(vmm_optname_args) ${BASH_REMATCH[1]}"
>  		elif [[ $line =~ ^(extra_params|qemu_params)\ *=\ *'"""'(.*)$ ]]; then
>  			opts=${BASH_REMATCH[2]}$'\n'
>  			while read -r -u $fd; do
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index bc17b89f4ff5..86d8a2cd8528 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -34,7 +34,7 @@ premature_failure()
>  get_cmdline()
>  {
>      local kernel=$1
> -    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
> +    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel $smp $test_args $opts"
>  }
>  
>  skip_nodefault()
> @@ -88,11 +88,6 @@ function run()
>      local accel="${10}"
>      local timeout="${11:-$TIMEOUT}" # unittests.cfg overrides the default
>  
> -    # If $test_args is empty, qemu will interpret the first option after -append
> -    # as a test argument instead of a qemu option, so make sure that doesn't
> -    # happen.
> -    [ -n "$test_args" ] && opts="-append $test_args $opts"
> -
>      if [ "${CONFIG_EFI}" == "y" ]; then
>          kernel=${kernel/%.flat/.efi}
>      fi
> diff --git a/scripts/vmm.bash b/scripts/vmm.bash
> index 8365c1424a3f..7629b2b9146e 100644
> --- a/scripts/vmm.bash
> +++ b/scripts/vmm.bash
> @@ -1,3 +1,18 @@
> +declare -A vmm_optname=(
> +	[qemu,args]='-append'
> +	[qemu,nr_cpus]='-smp'
> +)
> +
> +function vmm_optname_args()
> +{
> +	echo ${vmm_optname[$(vmm_get_target),args]}
> +}
> +
> +function vmm_optname_nr_cpus()
> +{
> +	echo ${vmm_optname[$(vmm_get_target),nr_cpus]}
> +}
> +
>  function vmm_get_target()
>  {
>  	if [[ -z "$TARGET" ]]; then
> -- 
> 2.50.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

