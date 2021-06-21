Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB473AF9C6
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 01:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbhFUXwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 19:52:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39772 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231486AbhFUXwe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 19:52:34 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15LNXKVT065867;
        Mon, 21 Jun 2021 19:50:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=eipUJqYEePrSLRSHzoaTR7BE/LaLdDKyMv+E8lKNlkQ=;
 b=ckTd/4GCcTyhvTWOb2hPurcQH8I18ytvx80VJ0yZ4kvnZQ2iCKCK+xEyT1ADaiUW4JtH
 JrC6/7AMtErWQMeNrVsikpYbXNaCCfaU++zn39j/DXmdWyiXZRXKv3HQAg9StRn5kDeQ
 vSTiq6IifZ6nzoa+23U4c+lLe9ESgiY9SOYFTOMSkP0Zqp9XYkBu4uBB0a2AyQm/pNZb
 9OPBpqLV2WfbpgklqdAXvxY7TvdBBO3dqge546rrU5RSf2UMAXPZIqKnC+4vHTCsOpuo
 MkFUTIvAc9jW3h4buON4PpNZ3iTTHqfzTvSiOKE2arjpvwuVcV6Bj+V2ZcRPzgIwLsy8 cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39b3tp9acs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 19:50:19 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15LNXYZt066106;
        Mon, 21 Jun 2021 19:50:18 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39b3tp9abu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 19:50:18 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15LNiql5011286;
        Mon, 21 Jun 2021 23:50:16 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 399878rm9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 23:50:16 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15LNmuV936831624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 23:48:56 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02D604C050;
        Mon, 21 Jun 2021 23:50:13 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7318C4C04A;
        Mon, 21 Jun 2021 23:50:12 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.57.69])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 21 Jun 2021 23:50:12 +0000 (GMT)
Date:   Tue, 22 Jun 2021 01:50:10 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio/s390: get rid of open-coded kvm hypercall
Message-ID: <20210622015010.1f02db8d.pasic@linux.ibm.com>
In-Reply-To: <20210621144522.1304273-1-hca@linux.ibm.com>
References: <20210621144522.1304273-1-hca@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1xazjH4FP6YqL4W59pT9TAGMNfAuK883
X-Proofpoint-GUID: b4o5pwT6SP9LqsWDlT-edFQpqIIPVi7K
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-21_14:2021-06-21,2021-06-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1011
 impostorscore=0 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106210138
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Jun 2021 16:45:22 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> do_kvm_notify() and __do_kvm_notify() are an (exact) open-coded variant
> of kvm_hypercall3(). Therefore simply make use of kvm_hypercall3(),
> and get rid of duplicated code.
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
