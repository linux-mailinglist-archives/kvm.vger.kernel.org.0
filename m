Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE69848D8AC
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 14:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235036AbiAMNSA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 08:18:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42918 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232469AbiAMNR7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 08:17:59 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20DCs8Gw009933;
        Thu, 13 Jan 2022 13:17:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=V7cyHYs7coITesRIuAb6fJcr+jEOk1HTxd6P1IxMZiA=;
 b=D+KlgDXJPLl5Hjg59Il3RIS4e2MXZEaCNzJqT3jSUuIyYnaPXlhvSuZ1hjVd6dVMJzXg
 te/B2NbJKgjlayU4Alu6v+bU9lP6YuDHVBFWPpXj9X5XDW44H68+bFhU/kp/j3/pezpD
 m0fZZVbOxzhN0ZAJ7RTGdmz/NbPAZ1f02IG3uV2uw0VwF/zHaRg4BhoABEFk3KLBtKJs
 rcO373PyD54rYQsFFNKhdWwPKekLro1+NAQ422PMEergMf/u6ZULACCNyh1BA9u0eUuE
 bHpQBRLPjj6/XHaOS/ZL7mB0e6nYMY0eXoLMKY4q2+njVpaOzh48mFbTaJzGV1paIL4O /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djknxhk08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 13:17:58 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20DDE83E007871;
        Thu, 13 Jan 2022 13:17:58 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djknxhjyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 13:17:58 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20DDBwai014688;
        Thu, 13 Jan 2022 13:17:56 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3dfwhjnt41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 13:17:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20DDHrog42860868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 13:17:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A4E3A4060;
        Thu, 13 Jan 2022 13:17:53 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF486A4064;
        Thu, 13 Jan 2022 13:17:52 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.156])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jan 2022 13:17:52 +0000 (GMT)
Date:   Thu, 13 Jan 2022 14:17:50 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, mhartmay@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 7/8] s390x: snippets: Add PV support
Message-ID: <20220113141750.78478ef3@p-imbrenda>
In-Reply-To: <62524574-a3c9-9024-7655-2a59725e557f@linux.ibm.com>
References: <20211123103956.2170-1-frankja@linux.ibm.com>
        <20211123103956.2170-8-frankja@linux.ibm.com>
        <20211123122219.3c18cf98@p-imbrenda>
        <08052bad-b494-c99b-27b3-bcfef0aa94fd@linux.ibm.com>
        <e0708a4f-8747-d1c5-229e-d06c8d67dcda@linux.ibm.com>
        <62524574-a3c9-9024-7655-2a59725e557f@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jTPTh1jFXJ5RB3X7gNdmS9c2bQ9ipXrI
X-Proofpoint-ORIG-GUID: dsYE4Pt9FpztM4yTQXtVRLzO_b8SO-ep
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_04,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Jan 2022 14:10:01 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 12/3/21 10:29, Janosch Frank wrote:
> > On 11/26/21 14:28, Janosch Frank wrote:  
> >> On 11/23/21 12:22, Claudio Imbrenda wrote:  
> >>> On Tue, 23 Nov 2021 10:39:55 +0000
> >>> Janosch Frank <frankja@linux.ibm.com> wrote:
> >>>  
> [...]
> >>> are they supposed to have different addresses?
> >>> the C files start at 0x4000, while the asm ones at 0  
> >>
> >> That's a mistake I'll need to fix.  
> > 
> > On second thought this is correct since it's the starting address of the
> > component and not the PSW entry. The psw entry is the next argument.
> > The C snippets currently have data in the first 4 pages so we can
> > encrypt from offset 0.
> > 
> > The question that remains is: do we need the data at 0x0 - 0x4000?
> > The reset and restart PSWs are not really necessary since we don't start
> > the snippets as a lpar or in simulation where we use these PSWs.
> > The stackptr is just that, a ptr AFAIK so there shouldn't be data on
> > 0x3000 (but I'll look that up anyway).  
> 
> Colleagues have used the C PV snippets over the last few weeks and 
> haven't reported any issues. It's time that we bring this into master 
> since a lot of upcoming tests are currently based on this series.
> 
> @Claudio: Any further comments?

no, let's bring this into master

