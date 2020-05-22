Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D251DE0AC
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 09:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgEVHMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 03:12:47 -0400
Received: from smtprelay0203.hostedemail.com ([216.40.44.203]:34716 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728384AbgEVHMr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 May 2020 03:12:47 -0400
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 May 2020 03:12:47 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave01.hostedemail.com (Postfix) with ESMTP id 9F26E18017BFE
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 07:03:57 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 5CB40100E7B40;
        Fri, 22 May 2020 07:03:56 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2525:2560:2563:2682:2685:2731:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3351:3622:3865:3870:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6742:9025:10004:10400:10848:11232:11657:11658:11914:12043:12297:12555:12679:12740:12760:12895:13069:13311:13357:13439:14096:14097:14181:14659:14721:21080:21451:21627:30054:30064:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: wax46_390cfe726d25
X-Filterd-Recvd-Size: 2396
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Fri, 22 May 2020 07:03:52 +0000 (UTC)
Message-ID: <e4847d1f25a1fd29ea3f8f8930ba5ae5ccc41f30.camel@perches.com>
Subject: Re: [PATCH v2 18/18] MAINTAINERS: Add entry for the Nitro Enclaves
 driver
From:   Joe Perches <joe@perches.com>
To:     Andra Paraschiv <andraprs@amazon.com>, linux-kernel@vger.kernel.org
Cc:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
Date:   Fri, 22 May 2020 00:03:51 -0700
In-Reply-To: <20200522062946.28973-19-andraprs@amazon.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
         <20200522062946.28973-19-andraprs@amazon.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2020-05-22 at 09:29 +0300, Andra Paraschiv wrote:

trivia:

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -11956,6 +11956,19 @@ S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lftan/nios2.git
>  F:	arch/nios2/
>  
> +NITRO ENCLAVES (NE)
> +M:	Andra Paraschiv <andraprs@amazon.com>
> +M:	Alexandru Vasile <lexnv@amazon.com>
> +M:	Alexandru Ciobotaru <alcioa@amazon.com>
> +L:	linux-kernel@vger.kernel.org
> +S:	Supported
> +W:	https://aws.amazon.com/ec2/nitro/nitro-enclaves/
> +F:	include/linux/nitro_enclaves.h
> +F:	include/uapi/linux/nitro_enclaves.h
> +F:	drivers/virt/nitro_enclaves/
> +F:	samples/nitro_enclaves/
> +F:	Documentation/nitro_enclaves/

Please keep the F: entries in case sensitive alphabetic order

F:	Documentation/nitro_enclaves/
F:	drivers/virt/nitro_enclaves/
F:	include/linux/nitro_enclaves.h
F:	include/uapi/linux/nitro_enclaves.h
F:	samples/nitro_enclaves/


