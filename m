Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205D83EF838
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 04:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbhHRCuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 22:50:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231449AbhHRCuE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Aug 2021 22:50:04 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17I2Xbkh178896;
        Tue, 17 Aug 2021 22:49:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=+6BQ94yJVmaI2Fu+VmqdYXcvuuOZRpOs2FcOeXGN+RA=;
 b=C7WtOP1xHf7tbQQAW/aFLzpm781/s3tJTiSZGoiTUhNZwBERASeYnSGVinhfjWi7XVNm
 xowlEP5jRmRrgMPN6rUK04Cl1yvanbodrVLTJwKJRHzkDWG45Y8r5peNVdRDmq85SObw
 VGKX3zqzHtern3QtnZLUSgXAXxx5NdAjNaCcUHt+ShM5o8ghu+F9d39ZpHztwdYzp0sQ
 u/kHISQRl5BTRhNnDPivLLJVmkbm2KDFpLTpbI0n72Z4IOZMjAuOKTaLMXMmJFBFfDmt
 FMTdNwTAKh6Oqie1KV4DPWBGPm/iCLwwjGOBRCF+bJCgzeRFsgm8OwugI44uLo6lT2QK IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3agf0e9wbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 22:49:26 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17I2ZRU8182823;
        Tue, 17 Aug 2021 22:49:25 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3agf0e9wbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 22:49:25 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17I2gFO1023498;
        Wed, 18 Aug 2021 02:49:24 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 3ae5fe99h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 02:49:24 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17I2nNTc44958168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 02:49:23 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49E1C78064;
        Wed, 18 Aug 2021 02:49:23 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4DC67805C;
        Wed, 18 Aug 2021 02:49:19 +0000 (GMT)
Received: from jarvis.lan (unknown [9.160.128.138])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 02:49:19 +0000 (GMT)
Message-ID: <c7b44991f9f96078b5d67eddf391f5e6eae7aff5.camel@linux.ibm.com>
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Steve Rutherford <srutherford@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Thomas Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Habkost, Eduardo" <ehabkost@redhat.com>,
        "S. Tsirkin, Michael" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Dov Murik <dovmurik@linux.vnet.ibm.com>,
        Hubertus Franke <frankeh@us.ibm.com>,
        David Gilbert <dgilbert@redhat.com>, kvm <kvm@vger.kernel.org>
Date:   Tue, 17 Aug 2021 22:49:18 -0400
In-Reply-To: <CABayD+cCeVw8QAUwD9qCxWN_tEm14k_o4VFM+s4r9uwypvkmSA@mail.gmail.com>
References: <cover.1629118207.git.ashish.kalra@amd.com>
         <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
         <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com>
         <CABayD+d4dHBMbshx_gMUxaHkJZENYYRMrzatDtS-a1awGQKv2A@mail.gmail.com>
         <CABgObfZbyTxSO9ScE0RMK2vgyOam_REo+SgLA+-1XyP=8Vx+uQ@mail.gmail.com>
         <b1b5adcdbf51112d7b3cc2c66123dea5276a4a6d.camel@linux.ibm.com>
         <CABayD+cCeVw8QAUwD9qCxWN_tEm14k_o4VFM+s4r9uwypvkmSA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SfOHr1ARLf-i_TefRs9cqp3jSg-SmtUK
X-Proofpoint-GUID: azzm65j96tps6cIfZhlnNAG2rT6H6lOX
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-17_09:2021-08-17,2021-08-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=535 priorityscore=1501
 malwarescore=0 mlxscore=0 impostorscore=0 clxscore=1015 suspectscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108180014
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-08-17 at 16:10 -0700, Steve Rutherford wrote:
> On Tue, Aug 17, 2021 at 3:57 PM James Bottomley <jejb@linux.ibm.com>
> wrote:
> > Realistically, migration is becoming a royal pain, not just for
> > confidential computing, but for virtual functions in general.  I
> > really think we should look at S3 suspend, where we shut down the
> > drivers and then reattach on S3 resume as the potential pathway to
> > getting migration working both for virtual functions and this use
> > case.
> 
> This type of migration seems a little bit less "live", which makes me
> concerned about its performance characteristics.

Well, there are too many scenarios we just fail at migration today.  We
need help from the guest to quiesce or shut down the interior devices,
and S3 suspend seems to be the machine signal for that.  I think in
most clouds guests would accept some loss of "liveness" for a gain in
reliability as long as we keep them within the SLA ... which is 5
minutes a year for 5 nines.  Most failed migrations also instantly fail
SLAs because of the recovery times involved so I don't see what's to be
achieved by keeping the current "we can migrate sometimes" approach.

James


