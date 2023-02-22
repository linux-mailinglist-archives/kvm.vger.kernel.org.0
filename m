Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCC369F92E
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 17:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjBVQki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 11:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbjBVQkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 11:40:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105E3311EC;
        Wed, 22 Feb 2023 08:40:35 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31MFLBrR000846;
        Wed, 22 Feb 2023 16:40:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RoDjxTOpH2ua+GK57HglMZDkYpeMIlRzFhxn3dxD0So=;
 b=TCtNoCs8UmTUnxPlfs21YoOlcPdgpggx0IbFW7mOKu29lr3m9kjyjL56VG8sUFnoVxSr
 /rnUDX9f7+PmE/fJ7JJzijrLzKVkfeDniBrnInF5FKqg/zeOt/YqXQkF/5z06iNai9oQ
 119H/nMYn71vMIlnu1CUSCPixBGrJLOC9dwkOOR4akxm/gabCC344FSdCUjZaUdMSZC6
 DizZ1zSqXrDa4ZngPa38igeZvtogu7VO1kkiUK4nLf3k+CG01goMIrKudyfqfBa692iu
 BmEsGQMJvplPOvxcDXgVvaj229qfJD+SvylceCeIDE0UVHKr9rDhnEt2RvB6Lx94zOZl cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwkr65uvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 16:40:35 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31MFU2Qq025593;
        Wed, 22 Feb 2023 16:40:34 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwkr65uv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 16:40:34 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31MGAoxt015814;
        Wed, 22 Feb 2023 16:40:34 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
        by ppma01wdc.us.ibm.com (PPS) with ESMTPS id 3ntpa718xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 16:40:34 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31MGeWwu36831768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 16:40:33 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A31158053;
        Wed, 22 Feb 2023 16:40:32 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A108A58043;
        Wed, 22 Feb 2023 16:40:31 +0000 (GMT)
Received: from [9.160.58.31] (unknown [9.160.58.31])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 22 Feb 2023 16:40:31 +0000 (GMT)
Message-ID: <84e1b18e-cd77-5b5a-abfa-6bf62c23d9ee@linux.ibm.com>
Date:   Wed, 22 Feb 2023 11:40:31 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v1 1/1] KVM: s390: pci: fix virtual-physical confusion on
 module unload/load
To:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        farman@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230222155503.43399-1-nrb@linux.ibm.com>
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20230222155503.43399-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7FYjpNHpyqweN3qlEx7NIrJBo4pJU62H
X-Proofpoint-ORIG-GUID: 3mrWl258oV-EgyyMpvCdIuEAEGEK-35U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_06,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302220145
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/23 10:55 AM, Nico Boehr wrote:
> When the kvm module is unloaded, zpci_setup_aipb() perists some data in the
> zpci_aipb structure in s390 pci code. Note that this struct is also passed
> to firmware in the zpci_set_irq_ctrl() call and thus the GAIT must be a
> physical address.
> 
> On module re-insertion, the GAIT is restored from this structure in
> zpci_reset_aipb(). But it is a physical address, hence this may cause
> issues when the kvm module is unloaded and loaded again.
> 
> Fix virtual vs physical address confusion (which currently are the same) by
> adding the necessary physical-to-virtual-conversion in zpci_reset_aipb().
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Yeah, that's right, in fact there is another address also stashed in the zpci_aipb which is also saved as physical addresses since, as you say, this structure is sent to firmware; the GAIT address just happens to be the one we care about at this spot, so I think it makes sense to leave zpci_aipb alone and just convert back to virt in this one place its needed.

Since we're looking at this bit of code, it's also worth noting that the other address restored here (aift->sbv) comes from zpci_aif_sbv which was instead stashed as a virtual address to begin with and that's why it doesn't need similar treatment.

Thanks Nico!

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>



