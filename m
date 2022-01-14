Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565DB48E910
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 12:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiANLUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 06:20:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6770 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240590AbiANLUG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 06:20:06 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EApt5l028949;
        Fri, 14 Jan 2022 11:20:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=sSPh1bH7U02kwfSfRZv21G0YvuyyltfH7kZbukUFzxM=;
 b=otB9E3ussorDVIMknyJ5PhB0oFDz+MKfL7A1bjKS719RCAyXH8si+cFeKwQ4cEsJXmFY
 3C6ksBd/M91K8SFjiqC8riZlkUAEDiNCxFxby+hgzyqgsgJcovEhYSW8W6lvprosC3QM
 4shL1fc1DPhmxXRlD+OsHLvBpg9oqw5qUcp7q+Uq/mhcRbnm+JDXGDmGHKfNKm3MUkME
 EYcL3JsWIrdGygDn4+/W7XwQxbaOYoVcyADLp8hKvffAIZse0MDWpP3GPcf/yd5ahlIX
 0aaV8Snr/39RlJ2KSbfdMcOwu+QPU5SPurURGcqM6O78eYvqXHdvg81H0r2h0CLNN94t Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk7sy8e8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 11:20:05 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EBK5GK025861;
        Fri, 14 Jan 2022 11:20:05 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk7sy8e7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 11:20:05 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EBD6UL010759;
        Fri, 14 Jan 2022 11:20:02 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3df28atnst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 11:20:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EBJxOc44106030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 11:19:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 576EA4C062;
        Fri, 14 Jan 2022 11:19:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE24F4C050;
        Fri, 14 Jan 2022 11:19:58 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.156])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 11:19:58 +0000 (GMT)
Date:   Fri, 14 Jan 2022 12:19:48 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 0/5] s390x: Allocation and hosting
 environment detection fixes
Message-ID: <20220114121948.566e77a6@p-imbrenda>
In-Reply-To: <20220114100245.8643-1-frankja@linux.ibm.com>
References: <20220114100245.8643-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SehHybn4ciOFmbB_SY7PBLrZcloKa9mQ
X-Proofpoint-ORIG-GUID: JicfF3B1Hw5KkB59_1iOmraiYl21AhWR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_04,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxscore=0 priorityscore=1501 phishscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 adultscore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jan 2022 10:02:40 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> I took some time before Christmas to write a test runner for lpar
> which automatically runs all tests and sends me the logs. It's based
> on the zhmc library to control starting and stopping of the lpar and
> works by having a menu entry for each kvm unit test.
> 
> This revealed a number of test fails when the tests are run under lpar
> as there are a few differences:
>    * lpars most often have a very high memory amount (upwards of 8GB)
>      compared to our qemu env (256MB)
>    * lpar supports diag308 subcode 2
>    * lpar does not provide virtio devices
> 
> The higher memory amount leads to allocations crossing the 2GB or 4GB
> border which made sclp and sigp calls fail that expect 31/32 bit
> addresses.
> 

the series looks good to me; if you send me a fixed patch 3, I'll queue
this together with the other ones

> Janosch Frank (5):
>   lib: s390x: vm: Add kvm and lpar vm queries
>   s390x: css: Skip if we're not run by qemu
>   s390x: diag308: Only test subcode 2 under QEMU
>   s390x: smp: Allocate memory in DMA31 space
>   s390x: firq: Fix sclp buffer allocation
> 
>  lib/s390x/vm.c  | 39 +++++++++++++++++++++++++++++++++++++++
>  lib/s390x/vm.h  | 23 +++++++++++++++++++++++
>  s390x/css.c     | 10 +++++++++-
>  s390x/diag308.c | 15 ++++++++++++++-
>  s390x/firq.c    |  2 +-
>  s390x/smp.c     |  4 ++--
>  s390x/stsi.c    | 21 +--------------------
>  7 files changed, 89 insertions(+), 25 deletions(-)
> 

