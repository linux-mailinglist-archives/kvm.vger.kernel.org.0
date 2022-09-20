Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D235BEDD4
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 21:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbiITTds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 15:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiITTdq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 15:33:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FFB71BFE;
        Tue, 20 Sep 2022 12:33:46 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KJSQwp020342;
        Tue, 20 Sep 2022 19:33:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3GCAFVBDKHorShrd3bGaiigFyfxMlogNipo3NZ9iNy8=;
 b=M9Z8+fZumtG+Ra0FyTJPVjvcD0K+RaSRHjaluGYc11vyaiUKlHP7N/ld5wq3Qd3X0su6
 wzsmubPL4MITY5EpV6O8jx2+/3QMRxrfTX0hYQVfrEBAXB9KseAH8eTxqg8dpyMje/Bk
 0UouI6v9RAhgum3P2mv7VtNDiKaZ/yt3uCAH41LZHo8UEInBVoaw966kZVo7MwqJHCnl
 c32xZZcZzbqD5GaT9+GkmzRZdUXMqg2wwZtDlrU7cg+rWeqMPGfr+MxqX3PKlF0FV097
 lQFRiN1vozsszI0Okcj2RTacWThFK3sdk6tPwgeDOmTAyb6CWnZeUm2uTNimR74ge7Ft Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jqkq405xf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 19:33:45 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28KJVvW7013760;
        Tue, 20 Sep 2022 19:33:45 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jqkq405vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 19:33:45 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28KJMPmH001897;
        Tue, 20 Sep 2022 19:28:43 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 3jn5v9wngv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 19:28:43 +0000
Received: from smtpav05.dal12v.mail.ibm.com ([9.208.128.132])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28KJSfJl10289844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 19:28:41 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D93D55805D;
        Tue, 20 Sep 2022 19:28:41 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B626F58056;
        Tue, 20 Sep 2022 19:28:40 +0000 (GMT)
Received: from [9.65.230.56] (unknown [9.65.230.56])
        by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Sep 2022 19:28:40 +0000 (GMT)
Message-ID: <ba5b32c4-4ece-6193-0788-2ce0dc20b235@linux.ibm.com>
Date:   Tue, 20 Sep 2022 15:28:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [RFC] KVM: s390: pci: register pci hooks without interpretation
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     farman@linux.ibm.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220920192739.135174-1-mjrosato@linux.ibm.com>
In-Reply-To: <20220920192739.135174-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Fhqb6diljukWh3__JJa6Phue0XYHkNgn
X-Proofpoint-GUID: JcRYABNNCfhPT7xfyu9ZRF91vTbGtKBU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_09,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=811
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200117
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/20/22 3:27 PM, Matthew Rosato wrote:
> The kvm registration hooks must be registered even if the facilities
> necessary for zPCI interpretation are unavailable, as vfio-pci-zdev will
> expect to use the hooks regardless.
> This fixes an issue where vfio-pci-zdev will fail its open function
> because of a missing kvm_register when running on hardware that does not
> support zPCI interpretation.
> 
> Fixes: ca922fecda6c ("KVM: s390: pci: Hook to access KVM lowlevel from VFIO")
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Ignore this, meant to send as a PATCH not RFC.

