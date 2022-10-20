Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074F8605F34
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 13:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbiJTLqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 07:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiJTLqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 07:46:12 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DA6136407
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 04:46:09 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KBbpqI038901
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:46:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=iArujqVFyK9ovgxZPJRWYu5drPDxXmS45h9nm7Q2MKE=;
 b=Xg+h5wtq6pgqkjKLkYlrRZxFYFdynV+CVeNdjR0ntLAQOAAEoZH+NwS3fFuQViaGeypM
 v/Er4AaXfTNJjeYmmRWDW8teg9gv+AA/+VCi+iKRxa98uAaOuuWt7Nd3iQB/hSGork1X
 GXRdHzRXS11XU5zHqj7mlJksFM1sQa0Y41rggtu4+XyoFGoXWEQt0S9T4vd31SXYJ8oW
 SUHr+3FVpSwxfFEOWS/dxMawe1rtOAaKlX2NmCYFoYrLfVgebRnhws4IAIH5fWOZTNSB
 DGNUX7PPINF8hUoyeizpwEFawxy+KTRKSjf7IbKQKxol5EfZDyIzGPVgE5A2jStKaYJc /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb4gpta22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:46:08 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29KBc7AP001105
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:46:07 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb4gpta1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 11:46:07 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29KBZxqp005791;
        Thu, 20 Oct 2022 11:46:05 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3k7mg98uyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 11:46:05 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29KBk2Y464749940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 11:46:02 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C920A4054;
        Thu, 20 Oct 2022 11:46:02 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C4A0A405F;
        Thu, 20 Oct 2022 11:46:02 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.239])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 11:46:01 +0000 (GMT)
Date:   Thu, 20 Oct 2022 13:45:59 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        seiden@linux.ibm.com, scgl@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/2] lib: s390x: terminate if PGM
 interrupt in interrupt handler
Message-ID: <20221020134559.609bba25@p-imbrenda>
In-Reply-To: <593e6d2f-e857-48c6-fa2d-158b83b4db4f@linux.ibm.com>
References: <20221018140951.127093-1-imbrenda@linux.ibm.com>
        <20221018140951.127093-2-imbrenda@linux.ibm.com>
        <166616486603.37435.2225106614844458657@t14-nrb>
        <20221019115128.2a8cbf13@p-imbrenda>
        <166625268562.6247.14921568293025628326@t14-nrb>
        <20221020105738.2af4ece0@p-imbrenda>
        <593e6d2f-e857-48c6-fa2d-158b83b4db4f@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: claesUtHNSWZN6PPoVLrhRb2ApiRDnGF
X-Proofpoint-ORIG-GUID: NVFD9EAmaOjBtDg1_mq4FO4N0tRlIg3H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_03,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxlogscore=805
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Oct 2022 13:19:36 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 10/20/22 10:57, Claudio Imbrenda wrote:
> > On Thu, 20 Oct 2022 09:58:05 +0200
> > Nico Boehr <nrb@linux.ibm.com> wrote:
> >   
> >> Quoting Claudio Imbrenda (2022-10-19 11:51:28)
> >> [...]  
> >>> I was thinking that we set pgm_int_expected = false so we would catch a
> >>> wild program interrupt there, but in hindsight maybe it's better to set
> >>> in_interrupt_handler = true there so we can abort immediately  
> >>
> >> Oh right I missed that. I think how it is right now is nicer because we will get a nice message on the console, right?  
> > 
> > which will generate more interrupts
> > 
> > @Janosch do you think it's better with or without setting
> > in_interrupt_handler in the pgm interrupt handler?
> >   
> 
> Any reason why you didn't set it in CALL_INT_HANDLER?

because then it will always be set whenever we get a PGM, the if will
always be true

> 
> >>
> >> In this case:
> >> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>  
> >   

