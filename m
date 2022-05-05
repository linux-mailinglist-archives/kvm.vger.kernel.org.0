Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E74B51BD09
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 12:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355345AbiEEKUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 06:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355580AbiEEKUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 06:20:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8306553A6A;
        Thu,  5 May 2022 03:16:30 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2459LWbS013230;
        Thu, 5 May 2022 10:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UdSj0Q24RTJ90Jlwr+Fj+QZMhcxvHd/jy1an4cse1OY=;
 b=f7OjRjs+idKg1g3autBXxMYSlpGBQf2ORGk9Ut7PATGiHQ5cm6hO+vT0NDNwDLJNpNvh
 QgRnompaRRyipoYAjidhiHocncuT8/lGV0+NGPxHv3e84IwQxQXARhuCFwY//ostjJar
 NZE2H3oBOzAW87r1Db7sE+rjtVWu4EyewdeZzuyguM56zHMrr12dAccc6sABVR02PbN4
 6UlvYnOn/F9HKUY1WYednbK+Yql88kXSI660IusxIyIussChtdgMKVFm4zYnV6F2oUF/
 Ohw42Zv6aBbgsLBjVW6zoTuoT+mrbBh7S5NZw7wEaq1i77NYe71CO+tgxGDiwCZvTcXP EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvbvnrxrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 10:16:28 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 245AGR7o001564;
        Thu, 5 May 2022 10:16:27 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvbvnrxr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 10:16:27 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 245ACkku009262;
        Thu, 5 May 2022 10:16:25 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3frvr8y188-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 10:16:25 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 245AGLaV33751438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 May 2022 10:16:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4F714C040;
        Thu,  5 May 2022 10:16:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF8824C046;
        Thu,  5 May 2022 10:16:20 +0000 (GMT)
Received: from [9.171.71.237] (unknown [9.171.71.237])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 May 2022 10:16:20 +0000 (GMT)
Message-ID: <f1d3896e-d6a5-e90f-c633-e670834d1765@linux.ibm.com>
Date:   Thu, 5 May 2022 12:16:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v6 11/21] KVM: s390: pci: do initial setup for AEN
 interpretation
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220426200842.98655-1-mjrosato@linux.ibm.com>
 <20220426200842.98655-12-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220426200842.98655-12-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 57De0f8BErD5dXeOxosoubLHqjQQEktq
X-Proofpoint-ORIG-GUID: wvYuKOXpGw49XJWt7jGThtvR75Dr9pXc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_04,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1011 priorityscore=1501
 suspectscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050071
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 26.04.22 um 22:08 schrieb Matthew Rosato:
[...]
> +/* Caller must hold the aift lock before calling this function */

When you do a next round, maybe use lockdep_assert_help instead of this comment

> +void kvm_s390_pci_aen_exit(void)
> +{
> +	unsigned long flags;
> +	struct kvm_zdev **gait_kzdev;
> +
> +	/*
> +	 * Contents of the aipb remain registered for the life of the host
> +	 * kernel, the information preserved in zpci_aipb and zpci_aif_sbv
> +	 * in case we insert the KVM module again later.  Clear the AIFT
> +	 * information and free anything not registered with underlying
> +	 * firmware.
> +	 */
> +	spin_lock_irqsave(&aift->gait_lock, flags);
> +	gait_kzdev = aift->kzdev;
> +	aift->gait = 0;
> +	aift->sbv = 0;
> +	aift->kzdev = 0;
> +	spin_unlock_irqrestore(&aift->gait_lock, flags);
> +
> +	kfree(gait_kzdev);
> +}
> +

Otherwise,

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

