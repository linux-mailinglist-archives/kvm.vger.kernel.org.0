Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1EA191AB6
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 21:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgCXUPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 16:15:16 -0400
Received: from nwk-aaemail-lapp03.apple.com ([17.151.62.68]:50688 "EHLO
        nwk-aaemail-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725941AbgCXUPQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 16:15:16 -0400
Received: from pps.filterd (nwk-aaemail-lapp03.apple.com [127.0.0.1])
        by nwk-aaemail-lapp03.apple.com (8.16.0.27/8.16.0.27) with SMTP id 02NMBmgB010185;
        Mon, 23 Mar 2020 15:16:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : content-type
 : mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=20180706;
 bh=BbtYnQ30+VQa0mqtIa/IoNSKh5bxaF/G/2mH/NZR/XM=;
 b=eigtfYpBAyFDMG5x4VReZAy7h0zMdXpA6xsRAvWz4+rO7GkLnja8Yc6+TwD23CV4N/03
 uIzUK6WelR4p5YKJPCeiIjfpfNM5pgBhdLTzUhXYaYsfT8r9iVxasV4kLlu24XC7swGd
 9UQAOp+FB1w3aKFWgxodIMX5Vi9zvucfLrUiGUnPtxNCUviok5OQv35Li7MSh1r5ftAB
 +980y1WOAl8oiE1TvpEs+Ivu1wC8e642e2kktOOKkKof3NaF9eF1d3b/b0oe4J+nU/Id
 sRRXliC0s/HDdPdXaBnJofDO9dw0ilBonoro81UReOdqevyeKFFqFcEFxCQNqqv4QfRe bQ== 
Received: from rn-mailsvcp-mta-lapp02.rno.apple.com (rn-mailsvcp-mta-lapp02.rno.apple.com [10.225.203.150])
        by nwk-aaemail-lapp03.apple.com with ESMTP id 2yx35hd6hs-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Mon, 23 Mar 2020 15:16:46 -0700
Received: from nwk-mmpp-sz13.apple.com
 (nwk-mmpp-sz13.apple.com [17.128.115.216])
 by rn-mailsvcp-mta-lapp02.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) with ESMTPS id <0Q7O00ECI37Y4C20@rn-mailsvcp-mta-lapp02.rno.apple.com>;
 Mon, 23 Mar 2020 15:16:46 -0700 (PDT)
Received: from process_milters-daemon.nwk-mmpp-sz13.apple.com by
 nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q7O00I002WWJ500@nwk-mmpp-sz13.apple.com>; Mon,
 23 Mar 2020 15:16:46 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: 20c0c410705af0c5efefeb0380f25862
X-Va-E-CD: 0d3627607ef3e3d98aa420b4b8633331
X-Va-R-CD: 4863190b8de0501ccbcc5f9161bb84b4
X-Va-CD: 0
X-Va-ID: 8b46cc00-2295-476e-8013-2ed406717002
X-V-A:  
X-V-T-CD: 20c0c410705af0c5efefeb0380f25862
X-V-E-CD: 0d3627607ef3e3d98aa420b4b8633331
X-V-R-CD: 4863190b8de0501ccbcc5f9161bb84b4
X-V-CD: 0
X-V-ID: 5798b9ec-53d1-4abc-8966-87180665790d
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_09:2020-03-23,2020-03-23 signatures=0
Received: from [17.234.34.141] (unknown [17.234.34.141])
 by nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q7O00L8Y37XII70@nwk-mmpp-sz13.apple.com>; Mon,
 23 Mar 2020 15:16:45 -0700 (PDT)
Content-type: text/plain; charset=us-ascii
MIME-version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH 1/2] scripts/arch-run: Support testing of
 hvf accel
From:   Cameron Esfahani <dirty@apple.com>
In-reply-to: <20200320145541.38578-2-r.bolshakov@yadro.com>
Date:   Mon, 23 Mar 2020 15:16:45 -0700
Cc:     kvm@vger.kernel.org
Content-transfer-encoding: 7bit
Message-id: <229CEA84-BD2D-4F9F-8307-8DDC2C21E946@apple.com>
References: <20200320145541.38578-1-r.bolshakov@yadro.com>
 <20200320145541.38578-2-r.bolshakov@yadro.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>
X-Mailer: Apple Mail (2.3445.104.11)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_09:2020-03-23,2020-03-23 signatures=0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Cameron Esfahani <dirty@apple.com>

Cameron Esfahani
dirty@apple.com

"The cake is a lie."

Common wisdom



> On Mar 20, 2020, at 7:55 AM, Roman Bolshakov <r.bolshakov@yadro.com> wrote:
> 
> The tests can be run if Hypervisor.framework API is available:
> 
>  https://developer.apple.com/documentation/hypervisor?language=objc#1676667
> 
> Cc: Cameron Esfahani <dirty@apple.com>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
> scripts/arch-run.bash | 13 +++++++++++++
> 1 file changed, 13 insertions(+)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index d3ca19d..197ae6c 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -315,17 +315,30 @@ kvm_available ()
> 		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
> }
> 
> +hvf_available ()
> +{
> +	[ "$(sysctl -n kern.hv_support 2>/dev/null)" = "1" ] || return 1
> +	[ "$HOST" = "$ARCH_NAME" ] ||
> +		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
> +}
> +
> get_qemu_accelerator ()
> {
> 	if [ "$ACCEL" = "kvm" ] && ! kvm_available; then
> 		echo "KVM is needed, but not available on this host" >&2
> 		return 2
> 	fi
> +	if [ "$ACCEL" = "hvf" ] && ! hvf_available; then
> +		echo "HVF is needed, but not available on this host" >&2
> +		return 2
> +	fi
> 
> 	if [ "$ACCEL" ]; then
> 		echo $ACCEL
> 	elif kvm_available; then
> 		echo kvm
> +	elif hvf_available; then
> +		echo hvf
> 	else
> 		echo tcg
> 	fi
> -- 
> 2.24.1
> 

