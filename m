Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1EE51BF99
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 14:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377321AbiEEMl5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 08:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377318AbiEEMlu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 08:41:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248DD5622B;
        Thu,  5 May 2022 05:38:11 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245C1HPQ026217;
        Thu, 5 May 2022 12:38:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=odvPWkiw3fJ3WIWEB/8YlaiWcSm6jGUoFQz5feUjDRU=;
 b=UbjUOylBTslRZifvs37EAyztr//9UzOUTGljwO6JTxT0pcbP/yyeU9g23fTUjSoluHLG
 +o66M9meF7qZbN2XqrZowesxN2K7cRQbyFJZa99KyW7LKzOwZdTpip7co/dEd0hziB1O
 QYdaAcjf2kDtCL/Kz2DrzOP8+18RK22FGrMcZFHyMHbiBZ647VEXIwHT1nT+eo/GLhGS
 o5m2f+IBFI4YKr+s08oXu+6mUAOmXhu+4X9vxKyq225jvTZnzftxVZvOVp7sb2KH5XqX
 NJrApzv6imxWIhHDhlB10FrDls66UtYq1jQvQ2Pi4GNgQ+vWaaKbVnmqOmtdpmbCRLQ1 kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fve7brrcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:38:08 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 245CKNAv023874;
        Thu, 5 May 2022 12:38:08 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fve7brrbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:38:07 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 245Cc58q022771;
        Thu, 5 May 2022 12:38:05 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3fttcj332p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:38:05 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 245CbuMq26673486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 May 2022 12:37:56 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DA294C052;
        Thu,  5 May 2022 12:38:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DDA54C044;
        Thu,  5 May 2022 12:38:00 +0000 (GMT)
Received: from [9.171.71.237] (unknown [9.171.71.237])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 May 2022 12:38:00 +0000 (GMT)
Message-ID: <c515a641-f250-44a7-4f84-e98836fe8413@linux.ibm.com>
Date:   Thu, 5 May 2022 14:37:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v6 12/21] KVM: s390: pci: enable host forwarding of
 Adapter Event Notifications
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
 <20220426200842.98655-13-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220426200842.98655-13-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yHDy4TRGECThlRzC47tyrW8kDJLbxR_N
X-Proofpoint-ORIG-GUID: mrUrup8vltRunbbXMVn95ljgI_LGWAN2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_05,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=983 clxscore=1015 priorityscore=1501 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050091
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

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

one comment below.


> +static void aen_process_gait(u8 isc)
> +{
> +	bool found = false, first = true;
> +	union zpci_sic_iib iib = {{0}};
> +	unsigned long si, flags;
> +
> +	spin_lock_irqsave(&aift->gait_lock, flags);

I think we can live with this for now, but if it turns out to create too long periods of disabled interrupts or lock hold times we might want to consider moving gaite access to an rcu-like approach.

> +
> +	if (!aift->gait) {
> +		spin_unlock_irqrestore(&aift->gait_lock, flags);
> +		return;
> +	}
> +
> +	for (si = 0;;) {
> +		/* Scan adapter summary indicator bit vector */
> +		si = airq_iv_scan(aift->sbv, si, airq_iv_end(aift->sbv));
> +		if (si == -1UL) {
> +			if (first || found) {
> +				/* Re-enable interrupts. */
> +				zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, isc,
> +						  &iib);
> +				first = found = false;
> +			} else {
> +				/* Interrupts on and all bits processed */
> +				break;
> +			}
> +			found = false;
> +			si = 0;
> +			/* Scan again after re-enabling interrupts */
> +			continue;
> +		}
> +		found = true;
> +		aen_host_forward(si);
> +	}
> +
> +	spin_unlock_irqrestore(&aift->gait_lock, flags);
> +}
> +

