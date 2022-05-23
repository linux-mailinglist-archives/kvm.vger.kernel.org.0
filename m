Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E1E5310F7
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 15:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbiEWNT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 09:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235970AbiEWNTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 09:19:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AB4BE18;
        Mon, 23 May 2022 06:19:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7A0AB810A1;
        Mon, 23 May 2022 13:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F713C385AA;
        Mon, 23 May 2022 13:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653311991;
        bh=OKE+ZuenSXOm0/gUqhu8yMEFf/CM7dUNVe8QIzkUxpQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YurQuzIoYUxDu8T8L43hTUM/EstcR8bENWhD5t4DR90NdfC16i3IXnN+OFa1a5GhY
         ZTxZx106k2g9PPHB913gLhyJj/jLZA11ipFZFFLkx77LZ1zN1p5Qi8f8uOYTlDdo7P
         T1G0Cle/KuDnJ4Nb9z6WK8QsmAOGW/GdrrhdzJnUPTSGUWV9ZjxUnwJ4N/AJBNhgAb
         u8VLoxYt76Gsk6VFv6lRFvPFlQzUCMqchb77r0TSR5+rLBXdNvJNJuUBCb9kTui9PX
         FXs7N9LAA/OzxdBq+w1J3+EdRYDN4anDnibut0uYcLPvv5SdjewG2JQlup9Sz7yin9
         3yx5C9zTcDVGg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 940F3400B1; Mon, 23 May 2022 10:19:48 -0300 (-03)
Date:   Mon, 23 May 2022 10:19:48 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Leo Yan <leo.yan@linaro.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V2 0/6] perf intel-pt: Add support for tracing KVM test
 programs
Message-ID: <YouJ9N7kpWPqRiXJ@kernel.org>
References: <20220517131011.6117-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220517131011.6117-1-adrian.hunter@intel.com>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Em Tue, May 17, 2022 at 04:10:05PM +0300, Adrian Hunter escreveu:
> Hi
> 
> A common case for KVM test programs is that the guest object code can be
> found in the hypervisor process (i.e. the test program running on the
> host).  Add support for that.
> 
> For some more details refer the 3rd patch "perf tools: Add guest_code
> support"
> 
> For an example, see the last patch "perf intel-pt: Add guest_code support"
> 
> For more information about Perf tools support for Intel® Processor Trace
> refer:
> 
>   https://perf.wiki.kernel.org/index.php/Perf_tools_support_for_Intel%C2%AE_Processor_Trace
> 
> 
> Changes in V2:
> 	Add more explanation to commits, comments and documentation.

Thanks, applied.

- Arnaldo

 
> 
> Adrian Hunter (6):
>       perf tools: Add machine to machines back pointer
>       perf tools: Factor out thread__set_guest_comm()
>       perf tools: Add guest_code support
>       perf script: Add guest_code support
>       perf kvm report: Add guest_code support
>       perf intel-pt: Add guest_code support
> 
>  tools/perf/Documentation/perf-intel-pt.txt |  70 ++++++++++++++++++++
>  tools/perf/Documentation/perf-kvm.txt      |   3 +
>  tools/perf/Documentation/perf-script.txt   |   4 ++
>  tools/perf/builtin-kvm.c                   |   2 +
>  tools/perf/builtin-script.c                |   5 +-
>  tools/perf/util/event.c                    |   7 +-
>  tools/perf/util/intel-pt.c                 |  20 +++++-
>  tools/perf/util/machine.c                  | 101 ++++++++++++++++++++++++++++-
>  tools/perf/util/machine.h                  |   4 ++
>  tools/perf/util/session.c                  |   7 ++
>  tools/perf/util/symbol_conf.h              |   3 +-
>  11 files changed, 217 insertions(+), 9 deletions(-)
> 
> 
> Regards
> Adrian

-- 

- Arnaldo
