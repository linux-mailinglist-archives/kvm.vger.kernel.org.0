Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A8453314E
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 21:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240871AbiEXTHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 15:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240924AbiEXTHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 15:07:08 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F08F24F21;
        Tue, 24 May 2022 12:06:58 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OIKlhL032304;
        Tue, 24 May 2022 19:06:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=/ue2Poc0hILLV7gtJGwQlryK+rzWjYj8WhQTasPSWSM=;
 b=By9KAOmMy1AENiNfjW5u/RLLWS0NiO3voDsYf9omiM5V9l54ANArKdeb1Kez40M3FCjV
 C9Sw9Gs2nx4dHyinI36JCOj1rgE02MptYVFG8OtzUkGf9NHJIrf4qLJOHDpYxrL6Nkn5
 PZtN6GBBujBM+kWCoIU6FC4ZoYmUKMez2bRRzcmt6WbrmYzcOwe1rK/KAOGKfWEf/Ya6
 oMl/kQcV0n/PXt5CNNlyLt1SjnJnO3NSqz1hZdys0kNoPG/Ew3Ac0NFeDq/VLMZuSC2R
 F/FO3zkddxTc5Z9f5NLur9VswEf+qPYY0o+CikLMTi9HYvLvgvO3wKE3OIgiwUYl8G2K ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g94jf0taq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:06:55 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OIxNWm015551;
        Tue, 24 May 2022 19:06:55 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g94jf0taa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:06:55 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OJ3BZe027630;
        Tue, 24 May 2022 19:06:54 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma05wdc.us.ibm.com with ESMTP id 3g93vb8kms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:06:54 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OJ6rK140370546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 19:06:53 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08B736A04F;
        Tue, 24 May 2022 19:06:53 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1ED86A04D;
        Tue, 24 May 2022 19:06:50 +0000 (GMT)
Received: from [9.163.3.233] (unknown [9.163.3.233])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 19:06:50 +0000 (GMT)
Message-ID: <59746b70-de0e-35ba-98e7-b30aed2c959f@linux.ibm.com>
Date:   Tue, 24 May 2022 15:06:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v8 00/22] KVM: s390: enable zPCI for interpretive
 execution
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220524185907.140285-1-mjrosato@linux.ibm.com>
In-Reply-To: <20220524185907.140285-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CdL2-EbQyPxa3yzWeIEN01TdyFEKb3DE
X-Proofpoint-GUID: QCs9xGvigEgT5HLJTZmptPIDfgLAPqhv
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=872
 priorityscore=1501 impostorscore=0 spamscore=0 suspectscore=0 adultscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205240094
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/22 2:58 PM, Matthew Rosato wrote:
> Note: this version of the series is built on top of vfio -next:
> https://github.com/awilliam/linux-vfio/tree/next
> As it now depends on 'vfio: remove VFIO_GROUP_NOTIFY_SET_KVM' and its
> prereqs.
> Additionally, if you care to try testing this series on top of vfio -next
> you'll also want to pick up this fix:
> https://lore.kernel.org/kvm/20220519182929.581898-1-mjrosato@linux.ibm.com/
> 
> ---
> 
> Enable interpretive execution of zPCI instructions + adapter interruption
> forwarding for s390x KVM vfio-pci.  This is done by triggering a routine
> when the VFIO group is associated with the KVM guest, transmitting to
> firmware a special token (GISA designation) to enable that specific guest
> for interpretive execution on that zPCI device.  Load/store interpreation
> enablement is then controlled by userspace (based upon whether or not a
> SHM bit is placed in the virtual function handle).  Adapter Event
> Notification interpretation is controlled from userspace via a new KVM
> ioctl.
> 
> By allowing intepretation of zPCI instructions and firmware delivery of
> interrupts to guests, we can reduce the frequency of guest SIE exits for
> zPCI.
> 
>  From the perspective of guest configuration, you passthrough zPCI devices
> in the same manner as before, with intepretation support being used by
> default if available in kernel+qemu.
> 
> Will follow up with a link an updated QEMU series.
> 

QEMU v6 series:
https://lore.kernel.org/kvm/20220524190305.140717-1-mjrosato@linux.ibm.com/

