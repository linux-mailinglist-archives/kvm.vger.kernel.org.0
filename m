Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7520490C62
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 17:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237490AbiAQQTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 11:19:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233071AbiAQQT2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 11:19:28 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HEH8xl025512;
        Mon, 17 Jan 2022 16:19:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=bDXcVQsbeCywWDYBlSvldtS7B0/2MOSts88Qrins7Ks=;
 b=rjgmzSi52LKUxBgBfuJEy1bGz3WdJ0Wh4w3z/R19rREtuXhk2mpG6UzXCP3vYmFgsARz
 4yyGvN5Umvetrp051KuYwVcBemFtB6bkA68auDQzvbdgzxAOpRMD3su9G6HPBfyPyUJb
 WkLCjBpNjwMoANyM6XAUjBV5tqfOcNEvYnlTgxnYv1Y70MBABNUxgyQP28DFT2NaGjfU
 AF4zhZtf7wPcF4eBtjjOW82NcjxyN+4DxygNUUKx87ng57f2JDBYsbxravOVRunvwpWc
 U152CypKgZk6N3ZZA4G4O7jbronqOyCFiwUmVd05VLewyBdEb7Rr6OpM4ocX8bJvIzzJ qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dn7kcpdrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:19:28 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HFMkgS000852;
        Mon, 17 Jan 2022 16:19:27 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dn7kcpdqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:19:27 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HGCxSQ006299;
        Mon, 17 Jan 2022 16:19:24 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3dknw94y56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:19:24 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HGA4DT18678136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 16:10:04 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99A154C05C;
        Mon, 17 Jan 2022 16:19:19 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 800734C04A;
        Mon, 17 Jan 2022 16:19:18 +0000 (GMT)
Received: from sig-9-145-177-193.de.ibm.com (unknown [9.145.177.193])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 16:19:18 +0000 (GMT)
Message-ID: <7f919a0f11d4381bb14ab7d0204db43a32a96517.camel@linux.ibm.com>
Subject: Re: [PATCH v2 07/30] s390/pci: externalize the SIC operation
 controls and routine
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 17 Jan 2022 17:19:18 +0100
In-Reply-To: <20220114203145.242984-8-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
         <20220114203145.242984-8-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WEaDADvDbA0FqNj6XOfQ1gbiWIGE4185
X-Proofpoint-GUID: Ubz-2jd02iDDB7ijCdpIFU4yRjAJ-y3m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1011 mlxlogscore=823
 adultscore=0 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201170102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-01-14 at 15:31 -0500, Matthew Rosato wrote:
> A subsequent patch will be issuing SIC from KVM -- export the necessary
> routine and make the operation control definitions available from a header.
> Because the routine will now be exported, let's rename __zpci_set_irq_ctrl
> to zpci_set_irq_ctrl and get rid of the zero'd iib wrapper function of
> the same name.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Looks good thank you!

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>

> ---
>  arch/s390/include/asm/pci_insn.h | 17 +++++++++--------
>  arch/s390/pci/pci_insn.c         |  3 ++-
>  arch/s390/pci/pci_irq.c          | 26 ++++++++++++--------------
>  3 files changed, 23 insertions(+), 23 deletions(-)
> 
> 
---8<---

