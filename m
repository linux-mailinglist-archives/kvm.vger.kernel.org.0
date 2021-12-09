Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99FA46EC55
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 16:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240668AbhLIP6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 10:58:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38384 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240624AbhLIP6B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 10:58:01 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9FZu9Z003189;
        Thu, 9 Dec 2021 15:54:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=BFSBV0h0s+qneGtaghD/MCG8lX99wogL4FQwzPgIEsk=;
 b=pdy7w29XZt7iIDdx9zapMEn3Cdd7MPzzXId/LGjX6OLCTp9pvcNVwBepQPFNuQ5Qp3Ft
 pHbvEFoWt+9rAp2qlAICoGIfuSDi9vHMBEhxM0tzOE8RJjOADvku/LibTxCgmAXOqxj/
 EhV8luX8QR2MaGbpgR5BQXf1K/HmrNwYRCDxGeExpPbrcU9wF4+jn7biGQg7CjenTd+W
 AARrbePuJd8y6C8XWZJdWciByCDd7wDjkBYTYlVEPTMiMP10yngPcU/h4xmm1zBv7132
 WdNWR/qFlPYd/H6XVNLD9qo10xU7N6nd3+zeflDieCh/WeltXFpRof1lDyCBil5fho93 Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cumja0em6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:54:27 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B9Fat6i008851;
        Thu, 9 Dec 2021 15:54:26 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cumja0ekt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:54:26 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B9FrRJV026184;
        Thu, 9 Dec 2021 15:54:24 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3cqyybb59w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:54:24 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B9FkYsc22610262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 15:46:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D282CAE057;
        Thu,  9 Dec 2021 15:54:19 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B6FCAE055;
        Thu,  9 Dec 2021 15:54:19 +0000 (GMT)
Received: from osiris (unknown [9.145.184.102])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  9 Dec 2021 15:54:19 +0000 (GMT)
Date:   Thu, 9 Dec 2021 16:54:17 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, gor@linux.ibm.com
Subject: Re: [PATCH v5 1/1] s390x: KVM: accept STSI for CPU topology
 information
Message-ID: <YbImqX/NEus71tZ1@osiris>
References: <20211122131443.66632-1-pmorel@linux.ibm.com>
 <20211122131443.66632-2-pmorel@linux.ibm.com>
 <20211209133616.650491fd@p-imbrenda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209133616.650491fd@p-imbrenda>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3Py32cFlbf1m0w5jzkAF65OWKHlzVEb7
X-Proofpoint-GUID: e4tUfDWOCbKKkIGusBBv---pWWTMFr7K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_07,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 bulkscore=0 mlxscore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0
 adultscore=0 suspectscore=0 mlxlogscore=869 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112090084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021 at 01:36:16PM +0100, Claudio Imbrenda wrote:
> On Mon, 22 Nov 2021 14:14:43 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
> > We let the userland hypervisor know if the machine support the CPU
> > topology facility using a new KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
> > 
> > The PTF instruction will report a topology change if there is any change
> > with a previous STSI_15_1_2 SYSIB.
> > Changes inside a STSI_15_1_2 SYSIB occur if CPU bits are set or clear
> > inside the CPU Topology List Entry CPU mask field, which happens with
> > changes in CPU polarization, dedication, CPU types and adding or
> > removing CPUs in a socket.
> > 
> > The reporting to the guest is done using the Multiprocessor
> > Topology-Change-Report (MTCR) bit of the utility entry of the guest's
> > SCA which will be cleared during the interpretation of PTF.
> > 
> > To check if the topology has been modified we use a new field of the
> > arch vCPU to save the previous real CPU ID at the end of a schedule
> > and verify on next schedule that the CPU used is in the same socket.
> > 
> > We assume in this patch:
> > - no polarization change: only horizontal polarization is currently
> >   used in linux.

Why is this assumption necessary? The statement that Linux runs only
with horizontal polarization is not true.
