Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD85C434941
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 12:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhJTKrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 06:47:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65020 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230235AbhJTKrh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 06:47:37 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KABLpM009597;
        Wed, 20 Oct 2021 06:45:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=EDYIhGku+KVMnQ5TfBBwBLRYd7vcScw0FLWf9FwaV40=;
 b=fQSfR1AgKt+wHC8PFDXYy7BGN5Ju7cmFzag/T5W8/nhxDXed/6+zAZKgISo5rGmoSDQt
 lsZDVChKd186UlFq8rUPLMeytkg4Pknq1QiL7pnZ8I7cfIW1KwjYNW6dHnhnDvSFSBlc
 pjxUutKYubTZrSU5jXR+nFELra56VTqSxS7XqKqb5knfnlHxl66vI4sPcFxHzZJKugaa
 tiLDAHRjR8/MWNlZ75MWEkwmr1XgPSI/OcyG8RtjmHTj5mNQ2clYnOZuImdKn1SPlSdw
 4cxbFh2+l9AJ1iHimow0ntvT554AVDFYeQgRhphr7+jqsT/Jt4FE+i9S9fjT+oG5ozL4 rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bth4x0k1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 06:45:23 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19KAjLSu017457;
        Wed, 20 Oct 2021 06:45:23 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bth4x0k0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 06:45:22 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19KAhbam032610;
        Wed, 20 Oct 2021 10:45:20 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3bqpca10qd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 10:45:20 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19KAdQsH52822276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 10:39:26 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F37FD52078;
        Wed, 20 Oct 2021 10:45:16 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.29.112])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 2CD9752076;
        Wed, 20 Oct 2021 10:45:16 +0000 (GMT)
Date:   Wed, 20 Oct 2021 12:45:13 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Michael Mueller <mimu@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, farman@linux.ibm.com,
        kvm@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 3/3] KVM: s390: clear kicked_mask if not idle after set
Message-ID: <20211020124513.6b90a15b.pasic@linux.ibm.com>
In-Reply-To: <ae8b3b11-2eef-0712-faee-5e3467d3e985@de.ibm.com>
References: <20211019175401.3757927-1-pasic@linux.ibm.com>
        <20211019175401.3757927-4-pasic@linux.ibm.com>
        <8cb919e7-e7ab-5ec1-591e-43f95f140d7b@linux.ibm.com>
        <ae8b3b11-2eef-0712-faee-5e3467d3e985@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TisAX4J2X2YFstPZcoy5UdTvGI97t3OS
X-Proofpoint-ORIG-GUID: QmdZV23ZkjfTHeT84G7i_g7pzw63RGBG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_04,2021-10-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=981 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 adultscore=0 clxscore=1015 phishscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Oct 2021 12:31:19 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> > Before releasing something like this, where none of us is sure if
> > it really saves cpu cost, I'd prefer to run some measurement with
> > the whole kicked_mask logic removed and to compare the number of
> > vcpu wake ups with the number of interrupts to be processed by
> > the gib alert mechanism in a slightly over committed host while
> > driving with Matthews test load.  
> 
> But I think patch 1 and 2 can go immediately as they measurably or
> testable fix things. Correct?

I think so as well. And if patch 3 is going to be dropped, I would
really like to keep the unconditional clear in kvm_arch_vcpu_runnable(),
as my analysis in the discussion points out: I think it can save us
form trouble this patch is trying to address.

Regards,
Halil
