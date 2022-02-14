Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2674B5594
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 17:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241613AbiBNQG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 11:06:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbiBNQGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 11:06:54 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C5D41991
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 08:06:46 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EFTdhJ022304
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 16:06:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=nH9erqnLUE0+OjB99vpE6/+aYwTL7xi39MDKkGDrWDA=;
 b=Jc9OmBH/FDKAPtQYnecpgr5bxZ8SixKee9ZTOeuqNZmYlymK3qQx+WheAXH+GkRmfv/1
 XPQN7ALI7wZ7jPY9sVWOvEO7a4Z9CDAPW4oD63G+QXVBwkYtm7iYJdQXs5cbxd4t5Q1a
 7ziz6GUXdBAWYI2D/YeXShajoailtvjkflGYJsFQzZXoIEnbzR1zeLQymbPgw95MgbYE
 vHLHlS5W6raOsiCA4JKycRCWPIuVwH+QdlAoa4w0wNAfJb2NCi6aTjAhH3N4UvtGpYFc
 f2ST2ZwGBn3u+k3bNSYr2u6kqdYoelKpi8RqgHqG1Zdp0lwyHGY13WSEl/NNrNeqPUJ4 EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e71jvv3d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 16:06:46 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21EG1Heb024932
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 16:06:45 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e71jvv3ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 16:06:45 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21EFvr0U024466;
        Mon, 14 Feb 2022 16:06:43 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3e64h9e647-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 16:06:43 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21EG6eMB16253228
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 16:06:40 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 221EFAE051;
        Mon, 14 Feb 2022 16:06:40 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFA33AE045;
        Mon, 14 Feb 2022 16:06:39 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.29.228])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Feb 2022 16:06:39 +0000 (GMT)
Message-ID: <141227b687b0869adc56ae0a867046058c3da408.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/6] s390x: firq: use CPU indexes
 instead of addresses
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        scgl@linux.ibm.com, seiden@linux.ibm.com
Date:   Mon, 14 Feb 2022 17:06:39 +0100
In-Reply-To: <20220204130855.39520-5-imbrenda@linux.ibm.com>
References: <20220204130855.39520-1-imbrenda@linux.ibm.com>
         <20220204130855.39520-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RIdSwv8lBpnROSBdpykRhDfZDgTyfqzZ
X-Proofpoint-GUID: TC4cp5ipSdX4L_TssthaH2bC-ouaRHLM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 clxscore=1015 spamscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-02-04 at 14:08 +0100, Claudio Imbrenda wrote:
> Adapt the test to the new semantics of the smp_* functions, and use
> CPU
> indexes instead of addresses.
> 
> replace the checks with asserts, the 3 CPUs are guaranteed to be
> there.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
