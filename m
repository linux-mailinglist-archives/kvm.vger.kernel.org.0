Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B52D221238
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 18:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgGOQZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 12:25:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50208 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgGOQZv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jul 2020 12:25:51 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06FG5jGJ102285;
        Wed, 15 Jul 2020 12:25:45 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 327u1jscrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 12:25:45 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06FG5jbm102297;
        Wed, 15 Jul 2020 12:25:44 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 327u1jscrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 12:25:44 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06FGP6CY004063;
        Wed, 15 Jul 2020 16:25:43 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma05wdc.us.ibm.com with ESMTP id 3275291wuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 16:25:43 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06FGPhIa22806888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 16:25:43 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1256512405B;
        Wed, 15 Jul 2020 16:25:43 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9C33124052;
        Wed, 15 Jul 2020 16:25:42 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.135.204])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTPS;
        Wed, 15 Jul 2020 16:25:42 +0000 (GMT)
Subject: Re: linux-next: manual merge of the kvms390 tree with the kvm tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>
References: <20200713145007.26acf3fb@canb.auug.org.au>
From:   Collin Walling <walling@linux.ibm.com>
Message-ID: <067cf82f-cc6d-968a-d1ab-53edc4e44114@linux.ibm.com>
Date:   Wed, 15 Jul 2020 12:25:42 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200713145007.26acf3fb@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_12:2020-07-15,2020-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 clxscore=1011 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150125
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/13/20 12:50 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the kvms390 tree got a conflict in:
> 
>   include/uapi/linux/kvm.h
> 
> between commit:
> 
>   1aa561b1a4c0 ("kvm: x86: Add "last CPU" to some KVM_EXIT information")
> 
> from the kvm tree and commit:
> 
>   23a60f834406 ("s390/kvm: diagnose 0x318 sync and reset")
> 
> from the kvms390 tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 

Much appreciated. This change is acceptable and should be properly
reflected in a header sync for QEMU (which I believe just copies the
files from the kernel?)

Thanks for the update.

-- 
Regards,
Collin

Stay safe and stay healthy
