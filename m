Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9DC9186CF6
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 15:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731467AbgCPOWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 10:22:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7286 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730724AbgCPOWp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 10:22:45 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02GEMVHt120514
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 10:22:44 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ytb3n82rr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 10:22:43 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Mon, 16 Mar 2020 14:22:41 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 16 Mar 2020 14:22:39 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02GELcED27263460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 14:21:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA5CA5206B;
        Mon, 16 Mar 2020 14:22:38 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.61])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6096452051;
        Mon, 16 Mar 2020 14:22:38 +0000 (GMT)
Date:   Mon, 16 Mar 2020 15:22:36 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH] KVM: s390: mark sie block as 512 byte aligned
In-Reply-To: <3b70e28f-a7d8-adfb-8f0b-de838d9c3b65@redhat.com>
References: <20200311083304.3725276-1-borntraeger@de.ibm.com>
        <20200316131009.381a8692@p-imbrenda>
        <3b70e28f-a7d8-adfb-8f0b-de838d9c3b65@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20031614-0020-0000-0000-000003B552FB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031614-0021-0000-0000-0000220DB2EE
Message-Id: <20200316152236.78ac27f9@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-16_03:2020-03-12,2020-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=988 bulkscore=0
 spamscore=0 adultscore=0 phishscore=0 clxscore=1015 malwarescore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160068
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Mar 2020 13:11:30 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 16.03.20 13:10, Claudio Imbrenda wrote:
> > On Wed, 11 Mar 2020 09:33:04 +0100
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> The sie block must be aligned to 512 bytes. Mark it as such.
> >>
> >> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >> ---
> >>  arch/s390/include/asm/kvm_host.h | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/s390/include/asm/kvm_host.h
> >> b/arch/s390/include/asm/kvm_host.h index 0ea82152d2f7..2d50f6c432e2
> >> 100644 --- a/arch/s390/include/asm/kvm_host.h
> >> +++ b/arch/s390/include/asm/kvm_host.h
> >> @@ -344,7 +344,7 @@ struct kvm_s390_sie_block {
> >>  	__u64	itdba;			/* 0x01e8 */
> >>  	__u64   riccbd;			/* 0x01f0 */
> >>  	__u64	gvrd;			/* 0x01f8 */
> >> -} __attribute__((packed));
> >> +} __packed __aligned(512);
> >>  
> >>  struct kvm_s390_itdb {
> >>  	__u8	data[256];  
> > 
> > I agree with the addition of aligned, but did you really have to
> > remove packed? it makes me a little uncomfortable.  
> 
> There is still "__packed".
> 

I had somehow totally missed it

this is what happens when you start working before actually waking up :D

