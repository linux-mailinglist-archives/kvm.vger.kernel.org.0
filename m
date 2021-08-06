Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B17F3E2773
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 11:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244604AbhHFJkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 05:40:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29106 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244184AbhHFJkO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Aug 2021 05:40:14 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1769XdLs095633;
        Fri, 6 Aug 2021 05:39:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Es24adhOplHrbQpzTAx/TK8IcWMvknJcpk9DIPx9bPc=;
 b=Yp1536M+UoTaAJ3cjbrt374gU67MAGzPpOtrKAQ9yG4q5G8tpnYBBNlSFkJiSzylegYp
 S5d9ecllj750efumwlUf1BZlNYA99XWM5MbgLUdZ/s9czYI77u+WMVmiVk32lYZaEGyM
 4g3KKkU2zg8d2VNLCbDYywmSK+9oxnC2LRb3GOQwgFICvZj6fdFcqVeTD3ToGVbz3mq0
 DVtyW7JJJA3AJ4cXGK+o3poBe8d+S8ddhGxxv/X2yebXejdEy6DoT6Zr6ZCsJ200a1Sl
 pMkuzu0JVgKj1bV7EXM8n+o9zKf0WaUyPzVyh6uXldagoY8GRLLfOF15hSE20O17z1Ng hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a8r5qwx3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 05:39:58 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1769YVkn101646;
        Fri, 6 Aug 2021 05:39:58 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a8r5qwx2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 05:39:58 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1769Vh8m007601;
        Fri, 6 Aug 2021 09:34:56 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3a4wshvyf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 09:34:56 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1769Yp6228836220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Aug 2021 09:34:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD55142056;
        Fri,  6 Aug 2021 09:34:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52A704204B;
        Fri,  6 Aug 2021 09:34:51 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.6.208])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Aug 2021 09:34:51 +0000 (GMT)
Date:   Fri, 6 Aug 2021 11:32:44 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: Re: [PATCH v3 03/14] KVM: s390: pv: leak the ASCE page when destroy
 fails
Message-ID: <20210806113244.4d0712d2@p-imbrenda>
In-Reply-To: <6b75cc71-b996-cf3d-ce57-dbcd475ebc3a@redhat.com>
References: <20210804154046.88552-1-imbrenda@linux.ibm.com>
        <20210804154046.88552-4-imbrenda@linux.ibm.com>
        <6b75cc71-b996-cf3d-ce57-dbcd475ebc3a@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 383vxRM3eEFQr1HkCojJn6nzT7c4RSec
X-Proofpoint-ORIG-GUID: 7GKBbEyUDX3-Aax2ZTLr8Ea1xTGqDHn1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-06_02:2021-08-05,2021-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 clxscore=1015 mlxscore=0 suspectscore=0 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108060067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Aug 2021 09:31:54 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 04.08.21 17:40, Claudio Imbrenda wrote:
> > When a protected VM is created, the topmost level of page tables of
> > its ASCE is marked by the Ultravisor; any attempt to use that
> > memory for protected virtualization will result in failure.
> > 
> > Only a successful Destroy Configuration UVC will remove the marking.
> > 
> > When the Destroy Configuration UVC fails, the topmost level of page
> > tables of the VM does not get its marking cleared; to avoid issues
> > it must not be used again.
> > 
> > Since the page becomes in practice unusable, we set it aside and
> > leak it.  
> 
> Instead of leaking, can't we add it to some list and try again later?
> Or do we only expect permanent errors?

once the secure VM has been destroyed unsuccessfully, there is nothing
that can be done, this is a permanent error

> Also, we really should bail out loud (pr_warn) to tell the admin that 
> something really nasty is going on.

when a destroy secure VM UVC fails, there are already other warnings
printed, no need to add one more

