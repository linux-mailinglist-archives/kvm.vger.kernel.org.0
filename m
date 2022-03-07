Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76764CFD68
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 12:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238166AbiCGLvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 06:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236012AbiCGLvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 06:51:11 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5769A6E56D;
        Mon,  7 Mar 2022 03:50:17 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2279JQRI006405;
        Mon, 7 Mar 2022 11:50:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=oKEMv2z309kPYq/UfCEEfeRDL0hWg3BtlKMnGnMfaQA=;
 b=Z/40spes6Db++DJvSxbzh+LVs3mkde3VQabo6HoQUl8nTN5pV0GeKQJAcb34I74Y21Q+
 NEn21mWCPryibIDKSveysWMGuPhu/MD8dfxtmij50pAOeCgcR8b9ESfU4iI9SiTpEBHy
 dw3vA3YkDkYXH6ZktRuOoe7DpfgkIWWqo+eF7X9k3+wQXUxsknKGD9n4sQv1Xo0yOCc4
 lKsYomeADN+a4BlDX0Z6PDCfKyzvvy5LObGkEZ/DI62XXhEcUGSFQvmwJFeyp39okHTs
 Cb7YsiH9Ly9sZhie/NwyM94PielgRuNSQSpa41jynXorRe71ZWeMY2uxYDnUT77pXmZ6 Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enfaptru9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 11:50:16 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 227BkA38019824;
        Mon, 7 Mar 2022 11:50:16 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enfaptrtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 11:50:16 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 227BksPi009430;
        Mon, 7 Mar 2022 11:50:14 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3eky4hvjqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 11:50:14 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 227Bd4Ko44892640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Mar 2022 11:39:04 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF6244203F;
        Mon,  7 Mar 2022 11:50:10 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9213142041;
        Mon,  7 Mar 2022 11:50:10 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.55.208])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Mar 2022 11:50:10 +0000 (GMT)
Message-ID: <77ac96f703c777b8b4a4c4785a3f35cac9eab9c4.camel@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests v1 1/6] lib: s390x: smp: Retry SIGP SENSE
 on CC2
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Mon, 07 Mar 2022 12:50:10 +0100
In-Reply-To: <20220303210425.1693486-2-farman@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
         <20220303210425.1693486-2-farman@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uOLHCC-XP7dK84QAEBKIo6BN8sruggm5
X-Proofpoint-GUID: R1xKmvtHhPAUjl3rVrjjANqeB60YIrYn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_04,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 impostorscore=0 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203070066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-03-03 at 22:04 +0100, Eric Farman wrote:
> The routine smp_cpu_stopped() issues a SIGP SENSE, and returns true
> if it received a CC1 (STATUS STORED) with the STOPPED or CHECK STOP
> bits enabled. Otherwise, it returns false.
> 
> This is misleading, because a CC2 (BUSY) merely indicates that the
> order code could not be processed, not that the CPU is operating.
> It could be operating but in the process of being stopped.
> 
> Convert the invocation of the SIGP SENSE to retry when a CC2 is
> received, so we get a more definitive answer.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

