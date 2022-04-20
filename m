Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867F450898B
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 15:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378881AbiDTNqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 09:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbiDTNqf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 09:46:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDB8433A9;
        Wed, 20 Apr 2022 06:43:50 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KD8PDf029086;
        Wed, 20 Apr 2022 13:43:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TQ89idDVj5DnsiPty35O+SNdf9oVI1XNdc4Vs+NJmRU=;
 b=PlCNhHPBHSzSPVmBWk0lT9IkkkZkI+nvVA5RFAOSUInoP2FGasVBHOSBwC/QeMvP8oqG
 PviCuNNkg2LsPeq/ETSVgE9B2cRuldC9iNn64Nt1ru90+n/6lFOOFFABYEJ6tcOf3iYg
 LwgqPsDg4U0c0qzTExugLPL+VbThLXu778muu6GoV6v7WUsHwSM3m81tHATojy5INpGG
 vSBf6at59xax1Ukf5/HKjnBpNjX6QXKNUI06oU0izzjA29qpIwDR7QMcQ4fh7uZqJx6L
 Xv7hdEbJ01PD7QkVcCEjhuWEzWiG6gHT9XoQ8c+6Je9AJ/9STS9EvEqRD9XGq7Tnagsb ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjdn3qmtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 13:43:49 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KCqXle007363;
        Wed, 20 Apr 2022 13:43:48 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjdn3qmt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 13:43:48 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KDhDlf031586;
        Wed, 20 Apr 2022 13:43:47 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03wdc.us.ibm.com with ESMTP id 3ffnea4mpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 13:43:47 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KDhkIt6030222
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 13:43:46 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B750FAE062;
        Wed, 20 Apr 2022 13:43:46 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D01DAE05C;
        Wed, 20 Apr 2022 13:43:41 +0000 (GMT)
Received: from [9.211.82.47] (unknown [9.211.82.47])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 20 Apr 2022 13:43:40 +0000 (GMT)
Message-ID: <0a8848fb-73b3-97aa-4147-9a647ceb2397@linux.ibm.com>
Date:   Wed, 20 Apr 2022 09:43:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v5 11/21] KVM: s390: pci: do initial setup for AEN
 interpretation
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
 <20220404174349.58530-12-mjrosato@linux.ibm.com>
 <c405e8de-5f6b-d33d-15e3-c4453e0348fe@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <c405e8de-5f6b-d33d-15e3-c4453e0348fe@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: p6G_grO_i8XKwRVty1YfCzZCf21NCMxf
X-Proofpoint-GUID: ONyjyGYwammObKJXRBzYE-UvW_WocnDI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_03,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200081
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/19/22 4:16 AM, Pierre Morel wrote:
> 
> 
> On 4/4/22 19:43, Matthew Rosato wrote:
>> Initial setup for Adapter Event Notification Interpretation for zPCI
>> passthrough devices.  Specifically, allocate a structure for 
>> forwarding of
>> adapter events and pass the address of this structure to firmware.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---

...

>> +
>> +static int zpci_reset_aipb(u8 nisc)
>> +{
>> +    /*
>> +     * AEN registration can only happen once per system boot.  If
>> +     * an aipb already exists then AEN was already registered and
>> +     * we can re-use the aipb contents.  This can only happen if
>> +     * the KVM module was removed and re-inserted.
>> +     */
>> +    if (zpci_aipb->aipb.faal != ZPCI_NR_DEVICES ||
>> +        zpci_aipb->aipb.afi != nisc) {
>> +        return -EINVAL;
>> +    }
> 
> I do not understand how faal cound be different of ZPCI_NR_DEVICES if 
> aipb has been already initialised.
> Same for afi.
> Can you please explain?

Well, my concern was along the lines of 'what if we rmmod kvm and then 
insmod a different version of the kvm module' -- These are really sanity 
checks.

Now, ZPCI_NR_DEVICES/faal is built in with PCI, so yeah this check is 
probably unnecessary as we shouldn't be able to change this value 
without a new kernel.

afi is however derived from nisc, which was passed in all the way from 
kvm_s390_gib_init during kvm_arch_init.  Today, this is hard-coded as 
GAL_ISC; but the point is that this is hard-coded within the kvm module, 
so we can't be quite sure that it's the same value every time we insmod 
kvm.  In an (admittedly, far-fetched) scenario where we insmod kvm, 
initialize AEN with GAL_ISC, rmmod kvm, then insmod a kvm where, for 
example, GAL_ISC was changed to a different number, we would need to 
trigger a failure here because we have no way to update the forwarding 
isc with firmware until the kernel is rebooted.
