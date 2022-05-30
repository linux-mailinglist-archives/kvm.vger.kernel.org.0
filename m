Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D03537B18
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 15:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbiE3NKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 09:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234192AbiE3NK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 09:10:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D0D70922;
        Mon, 30 May 2022 06:10:25 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24UBop4H014649;
        Mon, 30 May 2022 13:10:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ng21bU7ThRXYZ3QyAuku56OHtAHZGrEQ0rg6J0y21lQ=;
 b=SFJsb0QJWBbAsrJcNNdwW+ina+Q2hTUNiSmGMjsVvwTo85kdvhvgM+MT5y07pNsDwZOM
 c2fn+fLxeKCPD43tjlAUY+HR8apQgmFfUKL++kHkX8xkhnqka4aQLqT3+PFSrE/ah93A
 0VvrL35O7zpZtkL/6KCeEcSKC1+lmibfEWJWzeR2Z4cZ89heWEkHYxl8XOpCs3sIhVMr
 tuXuW+2uoUnA4uCFB4BrphxwlTcJqcJznTV9g0Svhk2J4vLts3cFatSODaurMtPqCDDj
 5BIgVP4qOvARmFczt7+24MoKbjdlrKpJy/Sch45fMUCHB50m0vXcSjkfRW9+DVJjbkvV fw== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcwdj1fgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 13:10:24 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24UD6hQN030846;
        Mon, 30 May 2022 13:10:22 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3gbcc6a1ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 13:10:22 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24UDAIha54919672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 13:10:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF94CA405F;
        Mon, 30 May 2022 13:10:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97297A405C;
        Mon, 30 May 2022 13:10:18 +0000 (GMT)
Received: from [9.171.2.176] (unknown [9.171.2.176])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 May 2022 13:10:18 +0000 (GMT)
Message-ID: <fd1fa794-1d23-ab95-f5d1-940621ccb2c7@linux.ibm.com>
Date:   Mon, 30 May 2022 15:10:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v6 00/11] kvm: s390: Add PV dump support
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
References: <20220517163629.3443-1-frankja@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220517163629.3443-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oZ99y21tR0ZPAKhCyWBWH6TVBifffSkD
X-Proofpoint-GUID: oZ99y21tR0ZPAKhCyWBWH6TVBifffSkD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_04,2022-05-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205300068
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 17.05.22 um 18:36 schrieb Janosch Frank:
> Sometimes dumping inside of a VM fails, is unavailable or doesn't
> yield the required data. For these occasions we dump the VM from the
> outside, writing memory and cpu data to a file.
> 
> Up to now PV guests only supported dumping from the inside of the
> guest through dumpers like KDUMP. A PV guest can be dumped from the
> hypervisor but the data will be stale and / or encrypted.
> 
> To get the actual state of the PV VM we need the help of the
> Ultravisor who safeguards the VM state. New UV calls have been added
> to initialize the dump, dump storage state data, dump cpu data and
> complete the dump process.
> 
> I chose not to document the dump data provided by the Ultravisor since
> KVM doesn't interprete it in any way. We're currently searching for a
> location and enough cycles to make it available to all.
> 
> v6:
> 	* Added patch that explains KVM's rc/rrc writes
> 	* Added rev-bys
> 	* Improved documentation
> 	* Reworked capability indication
> 	* Moved the dump completion into a new function

I queued this now for kvms390/next. Its likely too late for this merge window, though.
(I also applied the fixup proposed by Claudio in patch 6).
