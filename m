Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1A2434938
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 12:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhJTKrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 06:47:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17648 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230192AbhJTKrO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 06:47:14 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K9kuKw016184;
        Wed, 20 Oct 2021 06:45:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=5kEXniPUQ+0upV9eZLjZzFUw9tck45+BxrI9a5/jv8M=;
 b=X76TgwW1XOVLN4FkhHcKtNSIQPfsbadLn0h8KgHFSSBOLaYXfLcH5B7XVegNZi3jkDdH
 50hai984jfouUWaMqtqLUna3uCB7/2im47EMzzgjJ1+ktlgJj6OHIAgkMlBU7hENUBdg
 NJglC6M8fvNRdBjyk1tr5yRreEBenh0zaDzWZ9/BvABEhHkBjdwnKeW3wgsMBzISHJFN
 D93foLuvHfwG2FvQUbiT32yY+ICNOM9QTg0q8Wu3Tu6V3jF+tUXmDcIOAf3GbsMo4oQq
 otFaVisuz9lvDe/1EqcM/u8tonx0YWgJKOCYv/fGgxH5z/45Nk7SK+7W3rf0DxhpTq6n NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3btgsk94tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 06:44:59 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19KAIroU026588;
        Wed, 20 Oct 2021 06:44:59 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3btgsk94t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 06:44:59 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19KAhbad032610;
        Wed, 20 Oct 2021 10:44:57 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3bqpca10me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 10:44:57 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19KAd35H61407666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 10:39:03 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F810A4071;
        Wed, 20 Oct 2021 10:44:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63194A4075;
        Wed, 20 Oct 2021 10:44:53 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.68])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Oct 2021 10:44:53 +0000 (GMT)
Date:   Wed, 20 Oct 2021 12:42:11 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, farman@linux.ibm.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: s390: clear kicked_mask before sleeping again
Message-ID: <20211020124211.63c507c3@p-imbrenda>
In-Reply-To: <20211020101450.1edbbc1f.pasic@linux.ibm.com>
References: <20211019175401.3757927-1-pasic@linux.ibm.com>
        <20211019175401.3757927-2-pasic@linux.ibm.com>
        <20211020073515.3ad4c377@p-imbrenda>
        <1641267f-3a23-aba1-ab50-6f7c15e44528@de.ibm.com>
        <20211020080816.69d26708@p-imbrenda>
        <20211020101450.1edbbc1f.pasic@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rxEKbaxSoLxMeKzJLlcG77XbHlx1wMGM
X-Proofpoint-GUID: PyEHXLP_VlVbqxaZIHCVYt7qpRNLZwIT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_04,2021-10-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=749 adultscore=0 clxscore=1015 lowpriorityscore=0
 suspectscore=0 spamscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Oct 2021 10:14:50 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

[...]

> running, so I see no correctness issues there.

fair enough :)


