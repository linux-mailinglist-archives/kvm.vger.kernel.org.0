Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9430A63D85E
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 15:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiK3OjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 09:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiK3OjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 09:39:01 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329734841D;
        Wed, 30 Nov 2022 06:39:01 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AUEJRcK011132;
        Wed, 30 Nov 2022 14:39:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=05Lj4zyrQaiby3MKlnYsbf9g/eoD08n/S8JcLfx2p3c=;
 b=buon+cSeBfsvd+yKYO1WIMRO+x7FCAmkDgm2otznUUUflFAMlhYrO2FFNYvWqGthM2vu
 hzr7EVyJzne5QobO1lI8hZCbaxtjr958QXEchysXu8kYhwZSftMfHMTlDbb2fqkIztx0
 tQaWsoX92UTP7wJ6Fi2PTLAPk0YN0kE1JIGqU+c2pDaCVrAlflWO07B4cpXg5ARO0Ksx
 OYcY40SR7UC4J6k5ekWfcVFGPmpw8Ie+pF7p0yIHuy4dsDjPwRFjBrviFDmjv+cyFoJS
 Mv29E/qv8V2hXsUOaSqX5+AWfBnr/bXl80hE+gLK3B+BoWS8I3wI8B8lnl3DE9TItafU DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m65abp4yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 14:39:00 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AUDQGds026398;
        Wed, 30 Nov 2022 14:38:59 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m65abp4xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 14:38:59 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AUEZ0lF031147;
        Wed, 30 Nov 2022 14:38:57 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3m3ae94agd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 14:38:57 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AUEWOa264946626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Nov 2022 14:32:24 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 823A5A404D;
        Wed, 30 Nov 2022 14:38:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D0ECA4040;
        Wed, 30 Nov 2022 14:38:54 +0000 (GMT)
Received: from [9.179.5.143] (unknown [9.179.5.143])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Nov 2022 14:38:54 +0000 (GMT)
Message-ID: <44870720-bd9c-47b2-f08e-6ece37410498@linux.ibm.com>
Date:   Wed, 30 Nov 2022 15:38:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [kvm-unit-tests PATCH 5/5] lib: s390x: Handle debug prints for
 SIE exceptions correctly
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20221123084656.19864-1-frankja@linux.ibm.com>
 <20221123084656.19864-6-frankja@linux.ibm.com>
 <20221123140118.25114940@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20221123140118.25114940@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7Xk1BmmStJgfIeRl4lbcBfNrJX4T5StH
X-Proofpoint-GUID: i5tlS6TkJFIqP94xhlawWn0Ce_uxBsSn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 suspectscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 adultscore=0 malwarescore=0 mlxlogscore=917
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211300101
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/23/22 14:01, Claudio Imbrenda wrote:
> On Wed, 23 Nov 2022 08:46:56 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> When we leave SIE due to an exception, we'll still have guest values
>> in registers 0 - 13 and that's not clearly portraied in our debug
>> prints. So let's fix that.
> 
> wouldn't it be cleaner to restore the registers in the interrupt
> handler? (I thought we were already doing it)

You mean RESTORE_REGS_STACK? Please don't make me write this in assembly...

RESTORE_REGS_STACK is doing test/pgm register swapping, it doesn't care 
if the test registers are "host" or "guest" registers.
