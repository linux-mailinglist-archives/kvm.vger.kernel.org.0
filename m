Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75FE4C0EEB
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 10:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239215AbiBWJPE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 04:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbiBWJPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 04:15:03 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936ED81194
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 01:14:36 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21N8FvAb025084;
        Wed, 23 Feb 2022 09:14:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aoWMY7F1ZTQ4UTKwplNFjBsMTWANHUTvR1bVCpzVsUI=;
 b=mursHhk4xZyHsE6GQcTdtKwOXN2V9gRZa72dZ3bAIGNMwv+hvRtdWCQpfB77dHmqIukD
 sdc/55owIffX7154W5ppO55NdO1bqe1Cbf1JqYEi78Qlx23L+asnvQl6IjBeRG4yd8fd
 fX/f6OEbiUyj6id/AGxBUK88HhEp2dr83Ny6HHxOTZmggh9MDDydtTLerRRrvwbogE1K
 fiHGxQVRdT15Chd+ry1++2uRbIOoLL9ly/OFtfIlr0yTv4AzcUPOtX/naRxHURLVlq6E
 o9zHDF9+JnIH6rSa2v+nwcqBfRpVg2/teMtZdTtS5CmM14f7xK/KM9+yZU0MmM2e/QKF JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edh8xh0xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:14:26 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21N90P2N017315;
        Wed, 23 Feb 2022 09:14:26 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edh8xh0x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:14:26 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21N9D2tw030210;
        Wed, 23 Feb 2022 09:14:24 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3ear6972es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:14:24 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21N9EMn346662118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 09:14:22 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E452F52051;
        Wed, 23 Feb 2022 09:14:21 +0000 (GMT)
Received: from [9.171.70.253] (unknown [9.171.70.253])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 93EC652063;
        Wed, 23 Feb 2022 09:14:21 +0000 (GMT)
Message-ID: <6b123068-c982-1fcd-d09e-1a8f465147e3@linux.ibm.com>
Date:   Wed, 23 Feb 2022 10:14:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 0/3] KVM: PPC: Book3S PR: Fixes for AIL and SCV
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>
References: <20220222064727.2314380-1-npiggin@gmail.com>
 <bf6cf0d0-31bd-5751-4fbe-8193dbd716a9@redhat.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <bf6cf0d0-31bd-5751-4fbe-8193dbd716a9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Nf98TFWB_TXWzDeHVAcKkVLDXEyKiLxh
X-Proofpoint-GUID: LK6Epq12RwGYz57TWhe0_fvTfla7u34-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-23_03,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 clxscore=1011 suspectscore=0 phishscore=0 mlxlogscore=991
 adultscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 22.02.22 um 15:11 schrieb Paolo Bonzini:
> On 2/22/22 07:47, Nicholas Piggin wrote:
>> Patch 3 requires a KVM_CAP_PPC number allocated. QEMU maintainers are
>> happy with it (link in changelog) just waiting on KVM upstreaming. Do
>> you have objections to the series going to ppc/kvm tree first, or
>> another option is you could take patch 3 alone first (it's relatively
>> independent of the other 2) and ppc/kvm gets it from you?
> 
> Hi Nick,
> 
> I have pushed a topic branch kvm-cap-ppc-210 to kvm.git with just the definition and documentation of the capability.  ppc/kvm can apply your patch based on it (and drop the relevant parts of patch 3).  I'll send it to Linus this week.

We to have be careful with the 210 cap that was merged from the s390 tree.

